import itertools
import random
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def attention(i, priority=3, duration=30, topic="Norte"):
    return dict(id=i, name=f"Atención {i}", topic=topic, priority=priority, durationMinutes=duration)

def vet(i, capacity=2, minutes=60, specialty="Norte", available=True):
    return dict(id=i, name=f"Veterinario {i}", specialty=specialty, maxCapacity=capacity,
                availableMinutes=minutes, available=available)

def solve(a, v):
    response = client.post("/optimize", json=dict(attentions=a, veterinarians=v))
    assert response.status_code == 200, response.text
    return response.json()

def test_priority_and_time():
    r = solve([attention(1, 3, 40), attention(2, 2, 30), attention(3, 2, 30)], [vet(1)])
    assert r["objectiveValue"] == 4
    assert {a["attentionId"] for a in r["assignments"]} == {2, 3}

def test_compatibility_and_unavailable():
    r = solve([attention(1)], [vet(1, specialty="Sur"), vet(2, available=False)])
    assert r["assignments"] == [] and r["objectiveValue"] == 0
    assert "compatible" in r["unassigned"][0]["reason"]

def test_empty():
    assert solve([], [vet(1)])["objectiveValue"] == 0
    assert len(solve([attention(1)], [])["unassigned"]) == 1

def test_capacity_and_normalization():
    r = solve([attention(1, topic=" norte "), attention(2)], [vet(1, capacity=1)])
    assert len(r["assignments"]) == 1

def test_zero_capacity():
    assert solve([attention(1)], [vet(1, capacity=0)])["objectiveValue"] == 0

def test_invalid_and_duplicate():
    for a in ([attention(1, 4)], [attention(1, duration=0)], [attention(1), attention(1)]):
        assert client.post("/optimize", json=dict(attentions=a, veterinarians=[vet(1)])).status_code == 422

def test_against_exhaustive_enumeration():
    """Independent oracle over 20 small instances; checks optimum and feasibility."""
    rng = random.Random(42)
    for _ in range(20):
        a = [attention(i+1, rng.randint(1, 3), rng.choice([15, 30, 45]), rng.choice(["Norte", "Sur"])) for i in range(5)]
        v = [vet(j+1, rng.randint(0, 3), rng.choice([30, 60, 90]), rng.choice(["Norte", "Sur"]), rng.choice([True, True, False])) for j in range(2)]
        optimum = 0
        for choices in itertools.product([-1, 0, 1], repeat=len(a)):
            if any(j >= 0 and (not v[j]["available"] or a[i]["topic"] != v[j]["specialty"]) for i, j in enumerate(choices)):
                continue
            if any(sum(c == j for c in choices) > v[j]["maxCapacity"] or sum(a[i]["durationMinutes"] for i, c in enumerate(choices) if c == j) > v[j]["availableMinutes"] for j in range(2)):
                continue
            optimum = max(optimum, sum(a[i]["priority"] for i, j in enumerate(choices) if j >= 0))
        r = solve(a, v)
        assert r["objectiveValue"] == optimum
        assert len({x["attentionId"] for x in r["assignments"]}) == len(r["assignments"])
        for x in r["assignments"]:
            aa, vv = a[x["attentionId"]-1], v[x["veterinarianId"]-1]
            assert vv["available"] and aa["topic"] == vv["specialty"]
        for load in r["loads"]:
            assert load["usedMinutes"] <= load["availableMinutes"]
            assert load["assignedCount"] <= load["maxCapacity"]
