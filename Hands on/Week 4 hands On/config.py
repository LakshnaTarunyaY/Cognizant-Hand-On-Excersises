class Config:
    SECRET_KEY = "mysecretkey"
    SQLALCHEMY_DATABASE_URI = "sqlite:///coursemanager.db"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    DEBUG = True