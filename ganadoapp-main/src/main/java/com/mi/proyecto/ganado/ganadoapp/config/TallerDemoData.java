package com.mi.proyecto.ganado.ganadoapp.config;

import com.mi.proyecto.ganado.ganadoapp.mode.*;
import com.mi.proyecto.ganado.ganadoapp.repository.*;
import com.mi.proyecto.ganado.ganadoapp.service.UsuarioService;
import org.springframework.boot.ApplicationRunner;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;

/** Datos sintéticos, solo con perfil taller y activación explícita en una BD vacía. */
@Component @Profile("taller")
@ConditionalOnProperty(name="app.taller.seed", havingValue="true")
public class TallerDemoData implements ApplicationRunner {
 private final GanadoRepository ganado;
 private final VacunaRepository vacunas;
 private final UsuarioRepository usuarios;
 private final UsuarioService usuarioService;
 private final AtencionRepository atenciones;
 private final TurnoVeterinarioRepository turnos;
 private final String password;
 public TallerDemoData(GanadoRepository g,VacunaRepository v,UsuarioRepository u,UsuarioService us,
   AtencionRepository a,TurnoVeterinarioRepository t,@Value("${app.taller.demo-password}") String password) {
  ganado=g;vacunas=v;usuarios=u;usuarioService=us;atenciones=a;turnos=t;this.password=password;
 }
 @Override @Transactional
 public void run(ApplicationArguments args) {
  if(ganado.count()!=0 || vacunas.count()!=0 || atenciones.count()!=0 || turnos.count()!=0) return;
  LocalDate date=LocalDate.of(2026,11,4);
  String[] names={"BOV-DEMO-01 / dosis A","BOV-DEMO-02 / dosis B","BOV-DEMO-03 / dosis C","BOV-DEMO-04 / dosis D","BOV-DEMO-05 / dosis E","BOV-DEMO-06 / dosis F"};
  String[] zones={"Norte","Norte","Norte","Sur","Sur","Oriente"};
  int[] priority={3,2,1,3,2,3},duration={40,30,20,30,30,20};
  for(int i=0;i<6;i++) {
   var g=new Ganado("Bovino demo "+(i+1),"Demostración",400,3,"años","Hembra","Demostración","DEMO-0"+(i+1),"DEMO");
   g.setPropietario("Datos sintéticos del taller");ganado.save(g);
   var v=new Vacuna("Dosis demo "+(char)('A'+i),g);v.setFechaAplicacion(date.minusMonths(6));v.setProximaDosis(date.minusDays(i+1));v.setIntervaloCantidad(6);v.setUnidadTiempo("meses");v.setEstado("Vencida");vacunas.save(v);
   var a=new Atencion();a.setVacunaId(v.getId());a.setFecha(date);a.setName(names[i]);a.setTopic(zones[i]);a.setPriority(priority[i]);a.setDurationMinutes(duration[i]);atenciones.save(a);
  }
  String[] vetNames={"Veterinaria demo Norte","Veterinario demo Sur","Veterinaria demo sin turno"};
  for(int i=0;i<3;i++) {
   String email="vet"+(i+1)+"@bovicontrol.test";
   if(!usuarioService.existeCorreo(email)) usuarioService.registrarVeterinario(vetNames[i],email,password);
   var u=usuarios.findByCorreo(email).orElseThrow();
   var t=new TurnoVeterinario();t.setUsuarioId(u.getId());t.setName(vetNames[i]);t.setFecha(date);t.setSpecialty(i==0?"Norte":i==1?"Sur":"Oriente");t.setMaxCapacity(i==1?1:2);t.setAvailableMinutes(i==1?30:60);t.setAvailable(i!=2);turnos.save(t);
  }
 }
}
