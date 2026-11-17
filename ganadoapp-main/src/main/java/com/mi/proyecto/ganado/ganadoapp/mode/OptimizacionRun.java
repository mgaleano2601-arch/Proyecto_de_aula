package com.mi.proyecto.ganado.ganadoapp.mode;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
@Entity @Table(name="io_run")
public class OptimizacionRun {
 @Id @GeneratedValue(strategy=GenerationType.IDENTITY) private Long id;
 private LocalDate fecha;
 private LocalDateTime creadaEn;
 @Lob @Column(columnDefinition="LONGTEXT") private String requestJson;
 @Lob @Column(columnDefinition="LONGTEXT") private String responseJson;
 public Long getId(){return id;}
 public LocalDate getFecha(){return fecha;}
 public void setFecha(LocalDate v){fecha=v;}
 public LocalDateTime getCreadaEn(){return creadaEn;}
 public void setCreadaEn(LocalDateTime v){creadaEn=v;}
 public String getRequestJson(){return requestJson;}
 public void setRequestJson(String v){requestJson=v;}
 public String getResponseJson(){return responseJson;}
 public void setResponseJson(String v){responseJson=v;}
}
