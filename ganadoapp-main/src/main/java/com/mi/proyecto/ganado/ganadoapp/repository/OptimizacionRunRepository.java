package com.mi.proyecto.ganado.ganadoapp.repository;

import com.mi.proyecto.ganado.ganadoapp.mode.OptimizacionRun;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
public interface OptimizacionRunRepository extends JpaRepository<OptimizacionRun,Long> {
 List<OptimizacionRun> findTop20ByOrderByIdDesc();
}
