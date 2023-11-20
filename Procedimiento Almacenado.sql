
--exec ValidarEdad 27944949,1000000,2,5
--exec ValidarCredito 19376507,10000000,1
use simucredito
go
create or alter procedure ValidarCredito(@rut_cliente numeric (9),
										@monto_solicitado numeric(15),
										@Codigo_Credito varchar (5),
										@cod_retorno INT OUT,
										@Mensaje NVARCHAR(100) OUT
										)
as
begin
  -- validar que el monto solicitasdo esté dentro del rango
  declare @MONTO_MIN numeric(15)
  declare @MONTO_MAX numeric(15)
  
  select @monto_min = MONTO_MIN,
		 @monto_max  = MONTO_MAX
  from Credito where CODIGO = @Codigo_Credito

  if(@monto_solicitado >=@monto_min AND @monto_solicitado <=@monto_max)
	BEGIN
        SET @cod_retorno = 0;
        SET @Mensaje = 'Monto dentro del rango';
    END
  else
	  BEGIN
        SET @cod_retorno = 1;
        SET @Mensaje = 'Error monto fuera del rango';
    END
end
go
create or alter procedure ValidarEdad  (@rut_cliente numeric (9),
										@monto_solicitado numeric(9),
										@Codigo_Credito varchar (5),
										@plazo int,
										@cod_retorno INT OUT,
										@Mensaje NVARCHAR(100) OUT)
as
begin
  declare @fecha_nac date
  select @fecha_nac = fecha_nac
  from cliente where RUT = @rut_cliente

  declare @cliente_año_nac int
  declare @edad_cliente int

  select @cliente_año_nac = year(@fecha_nac)
  select @edad_cliente = year(getdate()) - @cliente_año_nac


  declare @edad_maxima int  
  DECLARE @PLAZO_MIN INT
  DECLARE @PLAZO_MAX INT


  select @edad_maxima = EDAD_MAX,
		 @PLAZO_MIN = PLAZO_MIN,
         @PLAZO_MAX = PLAZO_MAX

  from credito where codigo = @Codigo_Credito
  --+ @plazo
  if( @edad_cliente <= @edad_maxima AND @plazo >= @PLAZO_MIN AND @plazo <= @PLAZO_MAX)
	  BEGIN
        SET @cod_retorno = 0;
        SET @Mensaje = 'Edad y plazo válidos';
    END
  else
	  BEGIN
        SET @cod_retorno = 1;
        SET @Mensaje = 'Error, no cumple edad o plazo permitido';
    END
end