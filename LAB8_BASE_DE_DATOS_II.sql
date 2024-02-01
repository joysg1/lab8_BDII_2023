
--- PARTE #1


use almacen

--- 1. Crear una funcion que retorne el promedio de dos numeros

create function f_promedio
 (@valor1 decimal(4,2),
  @valor2 decimal(4,2)
 )
 returns decimal (6,2)
 as
 begin 
   declare @resultado decimal(6,2)
   set @resultado=(@valor1+@valor2)/2
   return @resultado
 end;

select dbo.f_promedio(5.5,8.5);


---- 2. Crear una funcion que dado un nombre y apellido lo retorne 
---- todo en mayuscula y lo separe por coma, todo en el mismo campo, ejemplo
---- Araujo, Gionella


create function f_nombre
(@nombre varchar(25),
 @apellido varchar(25)
 )
 returns varchar(50)
 as 
 begin

 declare @nombreMayus varchar(25)
 declare @apellidoMayus varchar(25)
 declare @result varchar(50)
 set @nombreMayus = UPPER(@nombre)
 set @apellidoMayus = UPPER(@apellido)
 set @result = @nombreMayus + ' , ' + @apellidoMayus
 return @result
 end;


 SELECT dbo.f_nombre('Gionella', 'Araujo');



 --- 2.1 Ejecute nuevamente la funcion anterior pero usando datos de la 
 --- tabla cliente de la BD almacen y que el resultado lo coloque en una columna
 ---- llamada nombrecompleto

 use almacen
 
 select * from cliente

 SELECT dbo.f_nombre(nombre, apellido) as NombreCompletoMayusCliente
 from cliente


 --- 3. Crear una funcion si dado el numero de dia se devuelva el dia de
 --- la semana en letras, ejemplo, si se ingresa un 5, debe salir viernes
 use almacen

 CREATE FUNCTION f_num_semana
(
    @numDia INT
)
RETURNS VARCHAR(25)
AS 
BEGIN 
    DECLARE @nomDia VARCHAR(25)

    SELECT @nomDia = 
        CASE @numDia
            WHEN 1 THEN 'Lunes'
            WHEN 2 THEN 'Martes'
            WHEN 3 THEN 'Miércoles'
            WHEN 4 THEN 'Jueves'
            WHEN 5 THEN 'Viernes'
            WHEN 6 THEN 'Sábado'
            WHEN 7 THEN 'Domingo'
            ELSE 'Número fuera de rango'
        END;

    RETURN @nomDia;
END;



SELECT dbo.f_num_semana(7) as DiaSemana;
SELECT dbo.f_num_semana(9) as DiaSemana;


--- 4. Crear una funcion que calcule el valor del itbms a los precios de los
---- productos usar la BD Almacen

use almacen

create function itbmsPrecios (

 @precio money

)

returns money
as
begin 

declare @itbms money

set @itbms = 0.07 * @precio

return @itbms

end;



SELECT dbo.itbmsPrecios(precio) as Impuesto_7_por_ciento, precio
from producto


select (precio * 0.07) from producto   --- Comprobando el calculo del impuesto



---- 5. Haga una copia de alguna de las funciones creadas y luego borrela


use almacen

create function itbmsPreciosCopia (

 @precio money

)

returns money
as
begin 

declare @itbms money

set @itbms = 0.07 * @precio

return @itbms

end;


drop function itbmsPreciosCopia




---- PARTE II Triggers

--- 1. Realice un trigger que indique un mensaje una vez de registro una vez se
---- inserte una sucursal nueva

use almacen

select * from sucursal

create trigger mensajeSucursal
on sucursal
for insert
as
print 'sucursal ingresada'
go

insert into sucursal(IDSUCURSAL, NOMBRE_SUCURSAL, CIUDAD, DIRECTOR)
values('P07','TOCUMEN','PANAMA','JORGE GOMEZ');


---- 2. Realizar un nuevo trigger que realice lo mismo, pero cuando se actualizce,
---- mostrar el mensaje: Sucursal actualizada satisfactoriamente

use almacen

create trigger mensajeActSucursal
on sucursal
for update
as 
print 'sucursal actualizada'
go


select * from sucursal

UPDATE sucursal
set NOMBRE_SUCURSAL = 'WESTLAND'
where NOMBRE_SUCURSAL = 'ONDGO'


--- 3. Implementar un trigger que permita crear una copia de los registros
--- que se insertan en la tabla producto, para dicho proceso implementar una
--- nueva tabla llamada PRODUCTObck

use almacen

select * from producto

create table PRODUCTObck(
id_producto char(4) primary key,
marca varchar(30),
modelo varchar(30),
descripcion varchar(32),
cantidad int,
precio money


)

select * from PRODUCTObck
select * from PRODUCTO

create trigger InsercionProducto 
on producto
after insert 
as
begin
insert into PRODUCTObck(id_producto, marca, modelo, descripcion, cantidad, precio)
select idproducto, marca, modelo, DESCRIPCCIÓN, cantidad, precio
from inserted
end;

insert into producto(idproducto, marca, modelo, DESCRIPCCIÓN, cantidad, precio)
values('S89', 'DELL', 'VOSTRO', 'LAPTOP', 15, 345.99);

SELECT * FROM PRODUCTObck






















