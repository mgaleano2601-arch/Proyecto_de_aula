package com.mi.proyecto.ganado.ganadoapp.repository;

import com.mi.proyecto.ganado.ganadoapp.mode.TurnoVeterinario;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.time.LocalDate;
public interface TurnoVeterinarioRepository extends JpaRepository<TurnoVeterinario, Long> {
 List<TurnoVeterinario> findByFechaOrderById(LocalDate fecha);
}
