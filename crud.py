from sqlalchemy.orm import Session
import models, schemas

def get_message(db: Session, message_id: int):
    return db.query(models.Messages).filter(models.Messages.id == message_id).first()

def create_message(db: Session, message: schemas.MessageCreate):
    db_message = models.Messages(**message.dict())
    db.add(db_message)
    db.commit()
    db.refresh(db_message)
    return db_message

def confirm_message(db: Session, message_id: int, linkcode: str, requestBody: str):
    db_message = db.query(models.Messages).filter(models.Messages.id == message_id).first()
    if db_message and db_message.linkcode == linkcode:
        db_message.requestBody = requestBody
        db_message.error = None  # Обработка ошибок может быть добавлена здесь
        db.commit()
        db.refresh(db_message)
    return db_message
