from fastapi import APIRouter, HTTPException
from pydantic import BaseModel

router = APIRouter()

class Contacto(BaseModel):
    name: str
    email: str
    subject: str
    message: str

@router.post("/api/contact", status_code=201)
async def crear_contacto(contacto: Contacto):
    if len(contacto.name) < 3:
        raise HTTPException(status_code=422, detail="El nombre es muy corto")
    
    return {"mensaje": "Consulta recibida", "datos": contacto}