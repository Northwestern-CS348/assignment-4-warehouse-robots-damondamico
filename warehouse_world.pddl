(define (domain warehouse)
	(:requirements :typing)
	(:types robot pallette - bigobject
        	location shipment order saleitem)

  	(:predicates
    	(ships ?s - shipment ?o - order)
    	(orders ?o - order ?si - saleitem)
    	(unstarted ?s - shipment)
    	(started ?s - shipment)
    	(complete ?s - shipment)
    	(includes ?s - shipment ?si - saleitem)

    	(free ?r - robot)
    	(has ?r - robot ?p - pallette)

    	(packing-location ?l - location)
    	(packing-at ?s - shipment ?l - location)
    	(available ?l - location)
    	(connected ?l - location ?l - location)
    	(at ?bo - bigobject ?l - location)
    	(no-robot ?l - location)
    	(no-pallette ?l - location)

    	(contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?s) (not (complete ?s)) (ships ?s ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?s) (packing-at ?s ?l) (not (unstarted ?s)) (not (available ?l)))
   )
   
   (:action robotMove
      :parameters (?r - robot ?l1 - location ?l2 - location)
      :precondition (and (free ?r) (at ?r ?l1) (no-robot ?l2) (connected ?l1 ?l2))
      :effect (and (no-robot ?l1) (not (at ?r ?l1)) (at ?r ?l2) (not (no-robot ?l2)))
   )
   
   (:action robotMoveWithPallette
      :parameters (?r - robot ?p - pallette ?l1 - location ?l2 - location)
      :precondition (and (free ?r) (at ?r ?l1) (at ?p ?l1) (no-robot ?l2) (no-pallette ?l2) (connected ?l1 ?l2))
      :effect (and (no-robot ?l1) (no-pallette ?l1) (not (at ?r ?l1)) (not (at ?p ?l1)) (at ?r ?l2) (at ?p ?l2) (not (no-robot ?l2)) (not (no-pallette ?l2)))
   )
   
   (:action moveItemFromPalletteToShipment
      :parameters (?l - location ?s - shipment ?si - saleitem ?o - order ?p - pallette)
      :precondition (and (ships ?s ?o) (orders ?o ?si) (started ?s) (not (complete ?s)) (packing-location ?l) (packing-at ?s ?l) (at ?p ?l) (contains ?p ?si) (not (includes ?s ?si)))
      :effect (and (not (contains ?p ?si)) (includes ?s ?si))
   )
   
   (:action completeShipment
      :parameters (?s - shipment ?o - order ?l - location)
      :precondition (and (ships ?s ?o) (started ?s) (not (complete ?s)) (packing-location ?l) (packing-at ?s ?l))
      :effect (and (complete ?s) (not (packing-at ?s ?l)) (not (packing-at ?s ?l)) (available ?l))
   )
)
