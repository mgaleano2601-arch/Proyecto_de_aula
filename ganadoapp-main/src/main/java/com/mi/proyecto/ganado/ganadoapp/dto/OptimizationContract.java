package com.mi.proyecto.ganado.ganadoapp.dto;

import java.util.List;
public final class OptimizationContract {
 private OptimizationContract() {}
 public record Attention(long id,String name,String topic,int priority,int durationMinutes) {}
 public record Veterinarian(long id,String name,String specialty,int maxCapacity,int availableMinutes,boolean available) {}
 public record Request(List<Attention> attentions,List<Veterinarian> veterinarians) {}
 public record Assignment(long attentionId,String attentionName,long veterinarianId,String veterinarianName,int score,int durationMinutes) {}
 public record Unassigned(long attentionId,String attentionName,String reason) {}
 public record Load(long veterinarianId,String veterinarianName,int assignedCount,int usedMinutes,int maxCapacity,int availableMinutes) {}
 public record Response(String status,int objectiveValue,List<Assignment> assignments,List<Unassigned> unassigned,List<Load> loads) {}
}
