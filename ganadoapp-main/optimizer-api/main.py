"""Asignación académica de atenciones de vacunación. No prescribe tratamientos."""
from typing import Annotated
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, ConfigDict, Field, model_validator
import pulp

app = FastAPI(title="BoviControl - Optimización de jornadas", version="1.0.0")

class StrictModel(BaseModel):
    model_config = ConfigDict(extra="forbid", str_strip_whitespace=True)

class Attention(StrictModel):
    id: Annotated[int, Field(gt=0)]
    name: Annotated[str, Field(min_length=1, max_length=120)]
    topic: Annotated[str, Field(min_length=1, max_length=60)]
    priority: Annotated[int, Field(ge=1, le=3)]
    durationMinutes: Annotated[int, Field(ge=1, le=480)]

class Veterinarian(StrictModel):
    id: Annotated[int, Field(gt=0)]
    name: Annotated[str, Field(min_length=1, max_length=120)]
    specialty: Annotated[str, Field(min_length=1, max_length=60)]
    maxCapacity: Annotated[int, Field(ge=0, le=100)]
    availableMinutes: Annotated[int, Field(ge=0, le=480)]
    available: bool

class OptimizationRequest(StrictModel):
    attentions: Annotated[list[Attention], Field(max_length=200)]
    veterinarians: Annotated[list[Veterinarian], Field(max_length=30)]

    @model_validator(mode="after")
    def unique_ids(self):
        for group in (self.attentions, self.veterinarians):
            if len({x.id for x in group}) != len(group):
                raise ValueError("Los identificadores deben ser únicos en cada lista")
        return self

class Assignment(StrictModel):
    attentionId: int
    attentionName: str
    veterinarianId: int
    veterinarianName: str
    score: int
    durationMinutes: int

class Unassigned(StrictModel):
    attentionId: int
    attentionName: str
    reason: str

class Load(StrictModel):
    veterinarianId: int
    veterinarianName: str
    assignedCount: int
    usedMinutes: int
    maxCapacity: int
    availableMinutes: int

class OptimizationResponse(StrictModel):
    status: str
    objectiveValue: int
    assignments: list[Assignment]
    unassigned: list[Unassigned]
    loads: list[Load]

@app.get("/health")
def health():
    return {"status": "ok", "solver": "CBC", "available": bool(pulp.PULP_CBC_CMD().available())}

@app.post("/optimize", response_model=OptimizationResponse)
def optimize(request: OptimizationRequest):
    attentions, vets = request.attentions, request.veterinarians
    # Only compatible and available pairs need decision variables (R2).
    pairs = [(a, v) for a in attentions for v in vets
             if v.available and a.topic.lower() == v.specialty.lower()]
    problem = pulp.LpProblem("BoviControlVaccination", pulp.LpMaximize)
    x = {(a.id, v.id): pulp.LpVariable(f"x_{a.id}_{v.id}", cat="Binary") for a, v in pairs}
    problem += pulp.lpSum(a.priority * x[a.id, v.id] for a, v in pairs)
    for a in attentions:
        problem += pulp.lpSum(x[a.id, v.id] for v in vets if (a.id, v.id) in x) <= 1
    for v in vets:
        problem += pulp.lpSum(x[a.id, v.id] for a in attentions if (a.id, v.id) in x) <= v.maxCapacity
        problem += pulp.lpSum(a.durationMinutes * x[a.id, v.id] for a in attentions if (a.id, v.id) in x) <= v.availableMinutes
    if pairs:
        try:
            problem.solve(pulp.PULP_CBC_CMD(msg=False, timeLimit=30, threads=1))
        except pulp.PulpSolverError as exc:
            raise HTTPException(503, "El solver CBC no está disponible") from exc
        # CBC may label a time-limited feasible solution 'Optimal' at problem level.
        if problem.status != pulp.LpStatusOptimal or problem.sol_status != pulp.LpSolutionOptimal:
            raise HTTPException(503, "No se demostró optimalidad dentro del límite de tiempo")
    assignments = [Assignment(attentionId=a.id, attentionName=a.name,
                             veterinarianId=v.id, veterinarianName=v.name,
                             score=a.priority, durationMinutes=a.durationMinutes)
                   for a, v in pairs if (pulp.value(x[a.id, v.id]) or 0) > 0.5]
    assigned = {a.attentionId for a in assignments}
    unassigned = []
    for a in attentions:
        if a.id not in assigned:
            candidates = [v for v in vets if v.available and a.topic.lower() == v.specialty.lower()]
            reason = ("Sin veterinario disponible y compatible" if not candidates else
                      "Ningún turno tiene capacidad individual suficiente" if not any(v.maxCapacity > 0 and v.availableMinutes >= a.durationMinutes for v in candidates) else
                      "No seleccionada en esta solución óptima con los recursos disponibles")
            unassigned.append(Unassigned(attentionId=a.id, attentionName=a.name, reason=reason))
    loads = [Load(veterinarianId=v.id, veterinarianName=v.name,
                  assignedCount=sum(a.veterinarianId == v.id for a in assignments),
                  usedMinutes=sum(a.durationMinutes for a in assignments if a.veterinarianId == v.id),
                  maxCapacity=v.maxCapacity, availableMinutes=v.availableMinutes) for v in vets]
    return OptimizationResponse(status="Optimal", objectiveValue=sum(a.score for a in assignments),
                                assignments=assignments, unassigned=unassigned, loads=loads)
