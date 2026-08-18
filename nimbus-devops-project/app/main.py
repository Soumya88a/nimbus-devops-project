import json
import logging
import os

from fastapi import FastAPI, HTTPException
from psycopg.errors import DatabaseError

from app.cache import check_cache, get as cache_get, set as cache_set
from app.db import check_db, get_connection, init_db
from app.models import Item, ItemCreate

logging.basicConfig(
    level=os.getenv("LOG_LEVEL", "INFO"),
    format="%(asctime)s %(levelname)s %(name)s %(message)s",
)
logger = logging.getLogger("nimbus")

app = FastAPI(title="Nimbus API", version="1.0.0")


@app.on_event("startup")
def startup() -> None:
    init_db()
    logger.info("nimbus_started env=%s", os.getenv("APP_ENV", "unknown"))


@app.get("/health")
def health():
    return {"status": "ok"}


@app.get("/ready")
def ready():
    db_ok = check_db()
    cache_ok = check_cache()
    status = "ready" if db_ok and cache_ok else "not_ready"
    return {"status": status, "database": db_ok, "cache": cache_ok}


@app.get("/api/v1/items", response_model=list[Item])
def list_items():
    cached = cache_get("items")
    if cached:
        return json.loads(cached)

    try:
        with get_connection() as conn:
            rows = conn.execute(
                "SELECT id, name FROM items ORDER BY id DESC LIMIT 100"
            ).fetchall()
        result = [dict(row) for row in rows]
        cache_set("items", json.dumps(result))
        return result
    except DatabaseError as exc:
        logger.exception("database_read_failed")
        raise HTTPException(status_code=503, detail="database unavailable") from exc


@app.post("/api/v1/items", response_model=Item, status_code=201)
def create_item(payload: ItemCreate):
    try:
        with get_connection() as conn:
            row = conn.execute(
                "INSERT INTO items(name) VALUES (%s) RETURNING id, name",
                (payload.name,),
            ).fetchone()
            conn.commit()
        cache_set("items", "[]", ttl=1)
        return row
    except DatabaseError as exc:
        logger.exception("database_write_failed")
        raise HTTPException(status_code=503, detail="database unavailable") from exc
