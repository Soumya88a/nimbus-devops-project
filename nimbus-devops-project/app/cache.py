import os
import redis

_client = redis.from_url(os.environ["REDIS_URL"], decode_responses=True)


def check_cache() -> bool:
    try:
        return _client.ping()
    except Exception:
        return False


def get(key: str):
    return _client.get(key)


def set(key: str, value: str, ttl: int = 60) -> None:
    _client.setex(key, ttl, value)
