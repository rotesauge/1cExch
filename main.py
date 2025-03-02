from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
import models, schemas, crud
from database import SessionLocal, engine

models.Base.metadata.create_all(bind=engine)

app = FastAPI()

# Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.post("/messages/", response_model=schemas.MessageCreate)
def create_message(message: schemas.MessageCreate, db: Session = Depends(get_db)):
    return crud.create_message(db=db, message=message)

@app.put("/messages/confirm/", response_model=schemas.MessageConfirm)
def confirm_message(message_id: int, linkcode: str, requestBody: str, db: Session = Depends(get_db)):
    return crud.confirm_message(db=db, message_id=message_id, linkcode=linkcode, requestBody=requestBody)




