package com.mi.proyecto.ganado.ganadoapp.service;
import com.mi.proyecto.ganado.ganadoapp.dto.OptimizationContract.*;
import org.junit.jupiter.api.Test;
import java.util.List;
import static org.junit.jupiter.api.Assertions.*;
class OptimizationServiceTest {
 Request request=new Request(List.of(new Attention(1,"Caso","Norte",3,40)),List.of(new Veterinarian(1,"Vet","Norte",1,60,true)));
 Assignment assignment=new Assignment(1,"Caso",1,"Vet",3,40);
 Response response(List<Assignment> a,int objective){return new Response("Optimal",objective,a,List.of(),List.of());}
 @Test void acceptsFeasibleResponse(){assertDoesNotThrow(()->OptimizationService.validate(request,response(List.of(assignment),3)));}
 @Test void rejectsDuplicate(){assertThrows(IllegalStateException.class,()->OptimizationService.validate(request,response(List.of(assignment,assignment),6)));}
 @Test void rejectsWrongScore(){assertThrows(IllegalStateException.class,()->OptimizationService.validate(request,response(List.of(assignment),4)));}
 @Test void rejectsTimeOverflow(){var r=new Request(request.attentions(),List.of(new Veterinarian(1,"Vet","Norte",1,30,true)));assertThrows(IllegalStateException.class,()->OptimizationService.validate(r,response(List.of(assignment),3)));}
 @Test void rejectsWrongZone(){var r=new Request(request.attentions(),List.of(new Veterinarian(1,"Vet","Sur",1,60,true)));assertThrows(IllegalStateException.class,()->OptimizationService.validate(r,response(List.of(assignment),3)));}
 @Test void rejectsMissingCase(){assertThrows(IllegalStateException.class,()->OptimizationService.validate(request,response(List.of(),0)));}
}
