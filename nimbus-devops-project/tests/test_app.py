from fastapi.testclient import TestClient

from app.main import app


def test_health():
    response = TestClient(app).get("/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}


def test_create_schema_model_validation():
    response = TestClient(app).post("/api/v1/items", json={"name": ""})
    assert response.status_code == 422
