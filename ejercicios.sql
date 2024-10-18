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
Crear un usuario llamado maria y asignarlo al grupo vendedores.
Otorgar al grupo vendedores permisos de SELECT e INSERT en la tabla productos.
Verificar que maria puede seleccionar e insertar productos en la tabla productos.
Revocar los permisos de INSERT del grupo vendedores y comprobar que maria ya no puede insertar.


-----
Ejercicio 2: Creación de Grupos y Control de Acceso
Crear un grupo llamado finanzas y otro grupo llamado operaciones.
Crear dos usuarios: carlos (miembro de finanzas) y ana (miembro de operaciones).
Otorgar permisos de SELECT y UPDATE en la tabla productos para el grupo finanzas, y solo permisos de SELECT para el grupo operaciones.
Verificar que carlos puede seleccionar y actualizar datos, mientras que ana solo puede seleccionar.
Revocar el permiso de UPDATE del grupo finanzas y verificar que carlos ya no puede actualizar datos en la tabla.
