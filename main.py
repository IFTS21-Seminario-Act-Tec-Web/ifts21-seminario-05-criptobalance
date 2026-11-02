"""
Servidor base del proyecto.
"""

# 1. Importamos FastAPI (el framework) y StaticFiles (para servir tu HTML/CSS/JS).
from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles

# 2. Importamos CORS. Esto es un "puente" de seguridad. 
# Como tu frontend corre en el puerto 5500 (Live Server) y FastAPI en el 8000, 
# sin esto el navegador bloquearía la conexión entre ellos.
from fastapi.middleware.cors import CORSMiddleware

# 3. Le decimos a Python que busque el archivo 'contact.py' 
# que creaste dentro de la carpeta 'src/routes'.
from src.routes import contact

# 4. Creamos la aplicación principal de FastAPI.
app = FastAPI(
    title="CriptoBalance",
    version="0.1.0",
)

# 5. Configuramos el CORS que importamos en el paso 2.
# allow_origins=["*"] significa que cualquier frontend (por ahora) puede hacer peticiones.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_methods=["*"],
    allow_headers=["*"],
)

# 6. Conectamos tu router (donde está el POST /api/contact) a la aplicación principal.
app.include_router(contact.router)

# 7. Esto le dice a FastAPI: "Si alguien entra a la raíz de la web, mostrale tu frontend".
# Va al final de todo para que no tape las rutas /api que creaste arriba.
app.mount("/", StaticFiles(directory="public", html=True), name="frontend")