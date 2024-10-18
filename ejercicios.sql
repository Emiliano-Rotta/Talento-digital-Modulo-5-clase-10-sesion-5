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
