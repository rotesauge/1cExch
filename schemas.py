from pydantic import BaseModel

class MessageCreate(BaseModel):
    id: int
    msgType_id: int
    sender_id: int
    body: str
    user: str
    code: str

class MessageConfirm(BaseModel):
    id: int
    linkcode: str
    requestBody: str
