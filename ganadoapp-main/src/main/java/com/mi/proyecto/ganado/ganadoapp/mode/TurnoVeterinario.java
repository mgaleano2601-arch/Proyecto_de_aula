package com.mi.proyecto.ganado.ganadoapp.mode;

import jakarta.persistence.*;
import jakarta.validation.constraints.*;

@Entity
@Table(name="io_turno", uniqueConstraints=@UniqueConstraint(columnNames={"fecha", "usuarioId"}))
public class TurnoVeterinario {
    @Id @GeneratedValue(strategy=GenerationType.IDENTITY)
    private Long id;
    @NotNull @org.springframework.format.annotation.DateTimeFormat(pattern="yyyy-MM-dd")
    private java.time.LocalDate fecha;
    @NotNull @Positive
    private Long usuarioId;
    @NotBlank @Size(max=120)
    private String name;
    @NotBlank @Size(max=60)
    private String specialty;
    @Min(0) @Max(100)
    private int maxCapacity;
    @Min(0) @Max(480)
    private int availableMinutes;
    
    private boolean available;
    public Long getId() { return id; }
    public void setId(Long value) { this.id=value; }
    public java.time.LocalDate getFecha() { return fecha; }
    public void setFecha(java.time.LocalDate value) { this.fecha=value; }
    public Long getUsuarioId() { return usuarioId; }
    public void setUsuarioId(Long value) { this.usuarioId=value; }
    public String getName() { return name; }
    public void setName(String value) { this.name=value; }
    public String getSpecialty() { return specialty; }
    public void setSpecialty(String value) { this.specialty=value; }
    public int getMaxCapacity() { return maxCapacity; }
    public void setMaxCapacity(int value) { this.maxCapacity=value; }
    public int getAvailableMinutes() { return availableMinutes; }
    public void setAvailableMinutes(int value) { this.availableMinutes=value; }
    public boolean getAvailable() { return available; }
    public void setAvailable(boolean value) { this.available=value; }
}
