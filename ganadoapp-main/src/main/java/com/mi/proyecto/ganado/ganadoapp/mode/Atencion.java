package com.mi.proyecto.ganado.ganadoapp.mode;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;

@Entity
@Table(name="io_atencion", uniqueConstraints=@UniqueConstraint(columnNames={"fecha", "vacunaId"}))
public class Atencion {
    @Id @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long id;
    @NotNull @org.springframework.format.annotation.DateTimeFormat(pattern="yyyy-MM-dd")
    private java.time.LocalDate fecha;
    @NotNull @Positive
    private Long vacunaId;
    @NotBlank @Size(max=120)
    private String name;
    @NotBlank @Size(max=60)
    private String topic;
    @Min(1) @Max(3)
    private int priority;
    @Min(1) @Max(480)
    private int durationMinutes;
    public Long getId() { return id; }
    public void setId(Long value) { this.id=value; }
    public java.time.LocalDate getFecha() { return fecha; }
    public void setFecha(java.time.LocalDate value) { this.fecha=value; }
    public Long getVacunaId() { return vacunaId; }
    public void setVacunaId(Long value) { this.vacunaId=value; }
    public String getName() { return name; }
    public void setName(String value) { this.name=value; }
    public String getTopic() { return topic; }
    public void setTopic(String value) { this.topic=value; }
    public int getPriority() { return priority; }
    public void setPriority(int value) { this.priority=value; }
    public int getDurationMinutes() { return durationMinutes; }
    public void setDurationMinutes(int value) { this.durationMinutes=value; }
}
