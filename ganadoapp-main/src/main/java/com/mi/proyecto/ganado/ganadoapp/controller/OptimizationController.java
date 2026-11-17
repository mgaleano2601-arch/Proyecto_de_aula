package com.mi.proyecto.ganado.ganadoapp.controller;

import com.mi.proyecto.ganado.ganadoapp.mode.*;
import com.mi.proyecto.ganado.ganadoapp.repository.*;
import com.mi.proyecto.ganado.ganadoapp.service.*;
import jakarta.validation.Valid;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import java.time.*;
@Controller @RequestMapping("/optimizacion")
public class OptimizationController {
 private final AtencionRepository attentions; private final TurnoVeterinarioRepository vets;
 private final OptimizacionRunRepository runs; private final OptimizationService service;
 private final VacunaRepository vacunas; private final UsuarioRepository users; private final CuentaEstadoService cuentas;
 public OptimizationController(AtencionRepository a,TurnoVeterinarioRepository v,OptimizacionRunRepository r,OptimizationService s,VacunaRepository vacunas,UsuarioRepository users,CuentaEstadoService cuentas) { attentions=a;vets=v;runs=r;service=s;this.vacunas=vacunas;this.users=users;this.cuentas=cuentas; }
 @GetMapping public String index(@RequestParam(required=false) @DateTimeFormat(iso=DateTimeFormat.ISO.DATE) LocalDate fecha,Model model) {
  if(fecha==null) fecha=LocalDate.now(ZoneId.of("America/Bogota"));
  model.addAttribute("fecha",fecha);model.addAttribute("attentions",attentions.findByFechaOrderById(fecha));model.addAttribute("vets",vets.findByFechaOrderById(fecha));model.addAttribute("runs",runs.findTop20ByOrderByIdDesc());return "optimization/index";
 }
 @GetMapping("/atenciones/nueva") public String newAttention(Model m) { var a=new Atencion();a.setFecha(LocalDate.now(ZoneId.of("America/Bogota")));a.setPriority(1);a.setDurationMinutes(30);m.addAttribute("atencion",a);return attentionForm(m); }
 @GetMapping("/atenciones/{id}") public String editAttention(@PathVariable Long id,Model m) {m.addAttribute("atencion",attentions.findById(id).orElseThrow(()->new ResponseStatusException(HttpStatus.NOT_FOUND)));return attentionForm(m);}
 private String attentionForm(Model m) {m.addAttribute("vacunas",vacunas.findAll());return "optimization/attention-form";}
 @PostMapping("/atenciones") public String saveAttention(@Valid @ModelAttribute("atencion") Atencion a,BindingResult b,Model m) {
  if(a.getId()!=null && !attentions.existsById(a.getId())) throw new ResponseStatusException(HttpStatus.NOT_FOUND);
  if(a.getVacunaId()!=null && !vacunas.existsById(a.getVacunaId())) b.rejectValue("vacunaId","invalid","Seleccione una vacuna existente.");
  if(a.getFecha()!=null && attentions.findByFechaOrderById(a.getFecha()).stream().anyMatch(x->java.util.Objects.equals(x.getVacunaId(),a.getVacunaId()) && !java.util.Objects.equals(x.getId(),a.getId()))) b.rejectValue("vacunaId","duplicate","Esta vacuna ya está en la jornada.");
  if(b.hasErrors()) return attentionForm(m);
  a.setName(a.getName().trim());a.setTopic(a.getTopic().trim());attentions.save(a);return "redirect:/optimizacion?fecha="+a.getFecha();
 }
 @PostMapping("/atenciones/{id}/eliminar") public String deleteAttention(@PathVariable Long id) {attentions.deleteById(id);return "redirect:/optimizacion";}
 @GetMapping("/turnos/nuevo") public String newVet(Model m) {var v=new TurnoVeterinario();v.setFecha(LocalDate.now(ZoneId.of("America/Bogota")));v.setMaxCapacity(2);v.setAvailableMinutes(60);v.setAvailable(true);m.addAttribute("turno",v);return vetForm(m);}
 @GetMapping("/turnos/{id}") public String editVet(@PathVariable Long id,Model m) {m.addAttribute("turno",vets.findById(id).orElseThrow(()->new ResponseStatusException(HttpStatus.NOT_FOUND)));return vetForm(m);}
 private String vetForm(Model m) {m.addAttribute("usuarios",users.findAll().stream().filter(u->"VETERINARIO".equals(u.getRol()) && cuentas.estaActivo(u.getId())).toList());return "optimization/vet-form";}
 @PostMapping("/turnos") public String saveVet(@Valid @ModelAttribute("turno") TurnoVeterinario v,BindingResult b,Model m) {
  if(v.getId()!=null && !vets.existsById(v.getId())) throw new ResponseStatusException(HttpStatus.NOT_FOUND);
  if(v.getUsuarioId()!=null && users.findById(v.getUsuarioId()).filter(u->"VETERINARIO".equals(u.getRol()) && cuentas.estaActivo(u.getId())).isEmpty()) b.rejectValue("usuarioId","invalid","Seleccione un veterinario activo.");
  if(v.getFecha()!=null && vets.findByFechaOrderById(v.getFecha()).stream().anyMatch(x->java.util.Objects.equals(x.getUsuarioId(),v.getUsuarioId()) && !java.util.Objects.equals(x.getId(),v.getId()))) b.rejectValue("usuarioId","duplicate","El veterinario ya tiene turno en esta jornada.");
  if(b.hasErrors()) return vetForm(m);
  v.setName(v.getName().trim());v.setSpecialty(v.getSpecialty().trim());vets.save(v);return "redirect:/optimizacion?fecha="+v.getFecha();
 }
 @PostMapping("/turnos/{id}/eliminar") public String deleteVet(@PathVariable Long id) {vets.deleteById(id);return "redirect:/optimizacion";}
 @PostMapping("/ejecutar") public String optimize(@RequestParam @DateTimeFormat(iso=DateTimeFormat.ISO.DATE) LocalDate fecha,RedirectAttributes flash) {
  try {return "redirect:/optimizacion/resultados/"+service.optimize(fecha).getId();} catch(IllegalStateException|IllegalArgumentException ex) {flash.addFlashAttribute("error",ex.getMessage());return "redirect:/optimizacion?fecha="+fecha;}
 }
 @GetMapping("/resultados/{id}") public String result(@PathVariable Long id,Model m) {var run=runs.findById(id).orElseThrow(()->new ResponseStatusException(HttpStatus.NOT_FOUND));m.addAttribute("run",run);m.addAttribute("result",service.result(run));return "optimization/result";}
}
