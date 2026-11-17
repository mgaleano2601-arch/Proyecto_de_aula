package com.mi.proyecto.ganado.ganadoapp.repository;

import com.mi.proyecto.ganado.ganadoapp.mode.Atencion;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.time.LocalDate;
public interface AtencionRepository extends JpaRepository<Atencion, Long> {
 List<Atencion> findByFechaOrderById(LocalDate fecha);
}
