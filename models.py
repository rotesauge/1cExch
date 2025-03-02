from sqlalchemy import Column, Integer, String, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from database import Base

class MessageTypes(Base):
    __tablename__ = 'MessageTypes'
    id = Column(Integer, primary_key=True)
    name = Column(String)

class Clients(Base):
    __tablename__ = 'Clients'
    id = Column(Integer, primary_key=True)
    name = Column(String)
    address = Column(String)
    type = Column(String)
    login = Column(String)
    password = Column(String)
    port = Column(Integer)

class Messages(Base):
    __tablename__ = 'Messages'
    id = Column(Integer, primary_key=True)
    code = Column(String)
    msgType_id = Column(Integer, ForeignKey('MessageTypes.id'))
    msgType = relationship("MessageTypes")
    endDate = Column(DateTime)
    sender_id = Column(Integer, ForeignKey('Clients.id'))
    sender = relationship("Clients", foreign_keys=[sender_id])
    receiver_id = Column(Integer, ForeignKey('Clients.id'))
    receiver = relationship("Clients", foreign_keys=[receiver_id])
    user = Column(String)
    body = Column(String)
    requestBody = Column(String)
    error = Column(String)
    point = Column(String)
    date = Column(DateTime)
    linkcode = Column(String)
    bodyhash = Column(String)
