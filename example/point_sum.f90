MODULE point_module
   TYPE point
      REAL :: x, y
   END TYPE point
   CONTAINS
      FUNCTION addpoints (p, q)
         TYPE (point), INTENT(IN) :: p, q
         TYPE (point) :: addpoints
         addpoints%x = p%x + q%x
         addpoints%y = p%y + q%y
      END FUNCTION addpoints

END MODULE point_module

PROGRAM point_sum
!A program unit would contain:
USE point_module

TYPE (point) :: px, py, pz

px = point(1., 2.)
py = point(2., 5.)
pz = addpoints(px, py)
PRINT*,' pz =', pz

END 

