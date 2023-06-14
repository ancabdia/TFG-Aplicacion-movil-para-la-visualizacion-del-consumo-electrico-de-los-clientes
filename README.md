# Aplicación móvil para la visualización del consumo eléctrico de los clientes
 <img src="assets/logo.png?raw=true"  width="20%" height="20%"> 


## Introducción al contexto del proyecto
### Descripción/motivación del proyecto
Con este proyecto final de carrera se pretende ofrecer de cara al usuario medio una plataforma para dispositivos móviles que, de manera intuitiva y amigable, permita visualizar los suministros a su nombre (independientemente de la distribuidora que los gestione) y permitir para cada uno de ellos, acceder al detalle del contrato y poder visualizar los consumos en diferentes periodos.
Esto será posible gracias a las posibilidades de acceso a la información que proporcionan el despliegue de contadores inteligentes llevado a cabo por las empresas de distribución eléctrica, las cuales ofrecen un amplio abanico de posibilidades a los clientes. [Datadis](https://www.datadis.es) es la plataforma de datos de consumo que proporciona la **Asociación de Empresas Eléctricas (ASEME)**, la cual dispone de una API privada de la cual se obtendrá la información de los suministros.
Finalmente, en cuanto a las tecnologías que se han utilizado a lo largo de la implementación de este trabajo han sido Dart, un lenguaje de programación gratuito y abierto a la comunidad, empleando para ello del “framework” de Flutter y en cuanto al lado del servidor se ha utilizado el gestor de base de datos de SQLite.

### Objetivos
- Facilitar a los usuarios finales el acceso a la información detallada sobre los consumos de sus suministros eléctricos, lo que les permitiría tomar medidas para reducir su consumo y, por tanto, un posible ahorro en su factura eléctrica.
- Proporcionar una plataforma de visualización de datos atractiva e intuitiva global que permita a los usuarios entender mejor su consumo eléctrico y su contrato con la distribuidora eléctrica.
- Ayudar a las empresas de distribución eléctrica a mejorar la gestión de la energía, proporcionándoles información detallada sobre el consumo eléctrico de sus usuarios.
- Contribuir a la mejora de la eficiencia energética y la sostenibilidad, fomentando la reducción del consumo eléctrico y, por tanto, la disminución de emisiones de 𝐶𝑂2.
Servir como herramienta de educación y concienciación sobre la importancia de la gestión del consumo eléctrico y su impacto en el medio ambiente.

## Stack Tecnológico
- Flutter
- SQLite

## Metodologías empleadas
- SCRUM
- Kanban

## Diagramas de caso de uso
### Casos de uso: usuario no registrado
![Diagrama caso de uso usuario no registrado](assets/diagrams/Usario_no_registrado_diagrama.svg)
### Casos de uso: usuario registrado
![Diagrama caso de uso usuario registrado](assets/diagrams/Usuario_registrado_diagrama.svg)

## Resultado final
### Registro
<img src="assets/screenshots/register.png?raw=true"  width="50%" height="50%"> <img src="assets/screenshots/register_2.png?raw=true"  width="50%" height="50%">

### Login
<img src="assets/screenshots/login.png?raw=true"  width="50%" height="50%"> <img src="assets/screenshots/error_login.png?raw=true"  width="50%" height="50%">

### Página de Inicio: Visualizar precio PVPC diario
<img src="assets/screenshots/home.png?raw=true"  width="50%" height="50%">

### Cambiar idioma
<img src="assets/screenshots/language.png?raw=true"  width="50%" height="50%">

### Ver suministros
<img src="assets/screenshots/supplies.png?raw=true"  width="50%" height="50%">

### Ver contrato
<img src="assets/screenshots/contract.png?raw=true"  width="50%" height="50%">

### Ver perfil
<img src="assets/screenshots/profile.png?raw=true"  width="50%" height="50%">
