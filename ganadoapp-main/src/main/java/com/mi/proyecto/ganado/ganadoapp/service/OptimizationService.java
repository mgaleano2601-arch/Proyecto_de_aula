package com.mi.proyecto.ganado.ganadoapp.service;

import com.mi.proyecto.ganado.ganadoapp.dto.OptimizationContract.*;
import com.mi.proyecto.ganado.ganadoapp.mode.*;
import com.mi.proyecto.ganado.ganadoapp.repository.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.client.RestClient;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import java.time.*;
import java.util.*;
@Service
public class OptimizationService {
 private final AtencionRepository attentions;
 private final TurnoVeterinarioRepository vets;
 private final OptimizacionRunRepository runs;
 private final VacunaRepository vacunas;
 private final UsuarioRepository usuarios;
 private final CuentaEstadoService cuentas;
 private final ObjectMapper mapper;
 private final RestClient client;
 public OptimizationService(AtencionRepository a,TurnoVeterinarioRepository v,OptimizacionRunRepository r,
   VacunaRepository vacunas,UsuarioRepository usuarios,CuentaEstadoService cuentas,ObjectMapper m,
   @Value("${optimizer.base-url:http://127.0.0.1:8000}") String url) {
  attentions=a; vets=v; runs=r; this.vacunas=vacunas; this.usuarios=usuarios; this.cuentas=cuentas; mapper=m;
  var factory=new SimpleClientHttpRequestFactory(); factory.setConnectTimeout(3000); factory.setReadTimeout(35000);
  client=RestClient.builder().baseUrl(url).requestFactory(factory).build();
 }
 public OptimizacionRun optimize(LocalDate date) {
  var cases=attentions.findByFechaOrderById(date); var shifts=vets.findByFechaOrderById(date);
  if(cases.size()>200 || shifts.size()>30) throw new IllegalArgumentException("Máximo 200 atenciones y 30 turnos por jornada.");
  if(cases.stream().anyMatch(a->!vacunas.existsById(a.getVacunaId()))) throw new IllegalArgumentException("Hay atenciones cuya vacuna fue eliminada. Revise la jornada.");
  for(var shift:shifts) {
   var user=usuarios.findById(shift.getUsuarioId()).orElseThrow(()->new IllegalArgumentException("Un veterinario fue eliminado."));
   if(!"VETERINARIO".equals(user.getRol()) || !cuentas.estaActivo(user.getId())) throw new IllegalArgumentException("Un turno pertenece a un usuario no habilitado como veterinario.");
  }
  var request=new Request(cases.stream().map(a->new Attention(a.getId(),a.getName(),a.getTopic(),a.getPriority(),a.getDurationMinutes())).toList(),
   shifts.stream().map(v->new Veterinarian(v.getId(),v.getName(),v.getSpecialty(),v.getMaxCapacity(),v.getAvailableMinutes(),v.getAvailable())).toList());
  try {
   var result=client.post().uri("/optimize").body(request).retrieve().body(Response.class);
   validate(request,result);
   var run=new OptimizacionRun(); run.setFecha(date); run.setCreadaEn(LocalDateTime.now(ZoneId.of("America/Bogota")));
   run.setRequestJson(mapper.writeValueAsString(request)); run.setResponseJson(mapper.writeValueAsString(result));
   return runs.save(run);
  } catch(Exception ex) { throw new IllegalStateException("No fue posible completar la optimización. Verifique FastAPI y los datos de la jornada.",ex); }
 }
 static void validate(Request request,Response response) {
  if(response==null || !"Optimal".equals(response.status()) || response.assignments()==null || response.unassigned()==null || response.loads()==null) throw new IllegalStateException("Respuesta incompleta o no óptima");
  Set<Long> used=new HashSet<>(); Map<Long,Integer> counts=new HashMap<>(),minutes=new HashMap<>(); int score=0;
  for(var x:response.assignments()) {
   var a=request.attentions().stream().filter(t->t.id()==x.attentionId()).findFirst().orElseThrow();
   var v=request.veterinarians().stream().filter(t->t.id()==x.veterinarianId()).findFirst().orElseThrow();
   if(!used.add(a.id()) || !v.available() || !a.topic().trim().equalsIgnoreCase(v.specialty().trim()) || x.score()!=a.priority() || x.durationMinutes()!=a.durationMinutes()) throw new IllegalStateException("Asignación inválida");
   counts.merge(v.id(),1,Integer::sum); minutes.merge(v.id(),a.durationMinutes(),Integer::sum); score+=a.priority();
  }
  for(var v:request.veterinarians()) if(counts.getOrDefault(v.id(),0)>v.maxCapacity() || minutes.getOrDefault(v.id(),0)>v.availableMinutes()) throw new IllegalStateException("Capacidad excedida");
  for(var u:response.unassigned()) if(!used.add(u.attentionId()) || request.attentions().stream().noneMatch(a->a.id()==u.attentionId())) throw new IllegalStateException("Caso sin asignar inválido");
  if(used.size()!=request.attentions().size() || score!=response.objectiveValue()) throw new IllegalStateException("Totales inconsistentes");
 }
 public Response result(OptimizacionRun run) { try { return mapper.readValue(run.getResponseJson(),Response.class); } catch(Exception e) {throw new IllegalStateException("Resultado ilegible",e);} }
}
