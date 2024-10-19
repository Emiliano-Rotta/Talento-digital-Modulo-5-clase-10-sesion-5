Grupos de usuarios y privilegios:

-GRANT
-REVOKE

Roles PSQL: son los permisos.

Roles de usuario (roles individuales)
Roles de grupo (pueden ser de varios usuarios)

Privilegios: Son permisos que se otorgan para realizar acciones específicas en la base de datos, tales como seleccionar (SELECT), insertar (INSERT), actualizar (UPDATE), o eliminar (DELETE) datos.

GRANT: Este comando se utiliza para otorgar permisos a un usuario o rol sobre objetos de la base de datos (tablas, vistas, secuencias, etc.).
GRANT SELECT ON productos TO analistas

REVOKE: Este comando elimina permisos previamente otorgados.
REVOKE SELECT ON productos FROM analistas;

--para crear un ROLE
CREATE ROLE nombre_del_grupo

--para agregar un usuario al grupo..
GRANT nombre_del_grupo TO emiliano;
GRANT nombre_del_grupo TO ghiselle;
GRANT nombre_del_grupo TO bernarda;

--para crear un usuario
CREATE USER emiliano WITH PASSWORD 'emi';


--Otorgar permisos a este grupo
GRANT SELECT, INSERT ON productos TO nombre_del_grupo

--eliminar permisos
REVOKE INSERT ON productos FROM nombre_del_grupo


----------------------------------
 CREATE ROLE profesor;
GRANT SELECT ON productos TO profesor;
CREATE USER emiliano WITH PASSWORD 'emi'
GRANT profesor TO emiliano

\c tienda emiliano (me va a pedir la contraseña)

SELECT * FROM productos; (me deja porque tengo el permiso)

Salir para revocar el permiso
REVOKE SELECT ON productos FROM profesor;

volver a entrar
\c tienda emiliano (me va a pedir la contraseña)

SELECT * FROM productos;
ERROR:  permiso denegado a la tabla productos

---------------------------------------------
Ejercicio 1: Gestión de Permisos con Grupos
Crear un grupo llamado vendedores.
CREATE ROLE vendedores;

Crear un usuario llamado maria y asignarlo al grupo vendedores.
CREATE USER maria WITH PASSWORD '123';
GRANT vendedores TO maria;

Otorgar al grupo vendedores permisos de SELECT e INSERT en la tabla productos.
GRANT SELECT, INSERT ON productos TO vendedores;

Verificar que maria puede seleccionar e insertar productos en la tabla productos.
\c tienda maria
SELECT * FROM productos;
INSERT INTO productos (nombre, precio) VALUES ('Altavoz', 80.00);

Revocar los permisos de INSERT del grupo vendedores y comprobar que maria ya no puede insertar.
\c tienda postgres
REVOKE INSERT ON productos FROM vendedores;
\c tienda maria
INSERT INTO productos (nombre, precio) VALUES ('Tablet', 250.00);



-----
Ejercicio 2: Creación de Grupos y Control de Acceso

Crear un grupo llamado finanzas y otro grupo llamado operaciones.
CREATE ROLE finanzas;
CREATE ROLE operaciones;

Crear dos usuarios: carlos (miembro de finanzas) y ana (miembro de operaciones).
CREATE USER carlos WITH PASSWORD 'carlos123';
CREATE USER ana WITH PASSWORD 'ana123';

GRANT finanzas TO carlos;
GRANT operaciones TO ana;

Otorgar permisos de SELECT y UPDATE en la tabla productos para el grupo finanzas, y solo permisos de SELECT para el grupo operaciones.
GRANT SELECT, UPDATE ON productos TO finanzas;
GRANT SELECT ON productos TO operaciones;

Verificar que carlos puede seleccionar y actualizar datos, mientras que ana solo puede seleccionar.
\c tienda carlos
SELECT * FROM productos;
UPDATE productos SET precio = 1300.00 WHERE nombre = 'Laptop';

\c tienda ana
SELECT * FROM productos;

UPDATE productos SET precio = 60.00 WHERE nombre = 'Mouse';
-- Debería resultar en un error de permisos

Revocar el permiso de UPDATE del grupo finanzas y verificar que carlos ya no puede actualizar datos en la tabla.
\c tienda postgres
REVOKE UPDATE ON productos FROM finanzas;
\c tienda carlos
UPDATE productos SET precio = 1350.00 WHERE nombre = 'Laptop';
-- Debería resultar en un error de permisos


---------------------------------------------------------------------------------------------
Ejercicio 1: Lugares Turísticos en Chile

Crear una base de datos llamada TurismoChile.
CREATE DATABASE TurismoChile;
\c TurismoChile

Crear dos tablas relacionadas:

lugares_turisticos: para almacenar información sobre lugares turísticos.
id_lugar (serial, primary key)
nombre_lugar (varchar(50), NOT NULL)
ubicacion (varchar(50), NOT NULL)
tipo (varchar(30), NOT NULL)

CREATE TABLE lugares_turisticos (
    id_lugar SERIAL PRIMARY KEY,
    nombre_lugar VARCHAR(50) NOT NULL,
    ubicacion VARCHAR(50) NOT NULL,
    tipo VARCHAR(30) NOT NULL
);


actividades: para listar actividades turísticas disponibles en cada lugar.
id_actividad (serial, primary key)
nombre_actividad (varchar(50), NOT NULL)
id_lugar (integer, references lugares_turisticos(id_lugar))

CREATE TABLE actividades (
    id_actividad SERIAL PRIMARY KEY,
    nombre_actividad VARCHAR(50) NOT NULL,
    id_lugar INTEGER REFERENCES lugares_turisticos(id_lugar)
);


Agregar 5 datos en total, distribuidos entre las dos tablas.
INSERT INTO lugares_turisticos (nombre_lugar, ubicacion, tipo)
VALUES
    ('Parque Nacional Torres del Paine', 'Magallanes', 'Parque Nacional'),
    ('San Pedro de Atacama', 'Antofagasta', 'Desierto'),
    ('Valparaíso', 'Valparaíso', 'Ciudad'),
    ('Isla de Pascua', 'Región de Valparaíso', 'Isla'),
    ('Lago Llanquihue', 'Los Lagos', 'Lago');

INSERT INTO actividades (nombre_actividad, id_lugar)
VALUES
    ('Senderismo', 1),
    ('Astronomía', 2),
    ('Recorrido Histórico', 3),
    ('Buceo', 4),
    ('Navegación', 5);



Modificar un dato en alguna de las tablas (puede ser cambiar el nombre de un lugar o actividad).
UPDATE lugares_turisticos
SET nombre_lugar = 'Torres del Paine'
WHERE nombre_lugar = 'Parque Nacional Torres del Paine';


Modificar la estructura de alguna tabla (por ejemplo, agregar una nueva columna).
ALTER TABLE lugares_turisticos
ADD COLUMN descripcion TEXT;


Eliminar un dato de alguna tabla.
DELETE FROM actividades
WHERE nombre_actividad = 'Buceo';


Realizar una transacción utilizando BEGIN, COMMIT y ROLLBACK:
Insertar un nuevo lugar y una nueva actividad.
Si la inserción falla, revertir los cambios.

BEGIN;

INSERT INTO lugares_turisticos (nombre_lugar, ubicacion, tipo)
VALUES ('Parque Vicente Pérez Rosales', 'Los Lagos', 'Parque Nacional');

INSERT INTO actividades (nombre_actividad, id_lugar)
VALUES ('Rafting', 6);

ROLLBACK;



Ejercicio 2: Deportes en Chile

Crear una base de datos llamada DeportesChile.
CREATE DATABASE DeportesChile;
\c DeportesChile

Crear dos tablas relacionadas:

deportes: para almacenar los diferentes deportes practicados en Chile.
id_deporte (serial, primary key)
nombre_deporte (varchar(50), NOT NULL)
categoria (varchar(30), NOT NULL)

CREATE TABLE deportes (
    id_deporte SERIAL PRIMARY KEY,
    nombre_deporte VARCHAR(50) NOT NULL,
    categoria VARCHAR(30) NOT NULL
);

eventos: para listar los eventos deportivos en Chile.
id_evento (serial, primary key)
nombre_evento (varchar(50), NOT NULL)
id_deporte (integer, references deportes(id_deporte))

CREATE TABLE eventos (
    id_evento SERIAL PRIMARY KEY,
    nombre_evento VARCHAR(50) NOT NULL,
    id_deporte INTEGER REFERENCES deportes(id_deporte)
);


Agregar 5 datos en total, distribuidos entre las dos tablas.
INSERT INTO deportes (nombre_deporte, categoria)
VALUES
    ('Fútbol', 'Equipo'),
    ('Tenis', 'Individual'),
    ('Ciclismo', 'Individual'),
    ('Atletismo', 'Individual'),
    ('Rugby', 'Equipo')

INSERT INTO eventos (nombre_evento, id_deporte)
VALUES
    ('Copa América', 1),
    ('Chile Open', 2),
    ('Vuelta a Chile', 3),
    ('Maratón de Santiago', 4),
    ('Campeonato Nacional de Rugby', 5);

Modificar un dato en alguna de las tablas (por ejemplo, cambiar el nombre de un deporte o evento).
UPDATE eventos
SET nombre_evento = 'Superclásico'
WHERE nombre_evento = 'Copa América'


Modificar la estructura de alguna tabla (por ejemplo, agregar una nueva columna).
ALTER TABLE deportes
ADD COLUMN popularidad INTEGER;

Eliminar un dato de alguna tabla.
DELETE FROM eventos
WHERE nombre_evento = 'Maratón de Santiago';

Realizar una transacción utilizando BEGIN, COMMIT y ROLLBACK:
Insertar un nuevo deporte y un nuevo evento.
Si la inserción falla, revertir los cambios.

BEGIN;

INSERT INTO deportes (nombre_deporte, categoria)
VALUES ('Surf', 'Individual');

INSERT INTO eventos (nombre_evento, id_deporte)
VALUES ('Campeonato Nacional de Surf', 6);

COMMIT;