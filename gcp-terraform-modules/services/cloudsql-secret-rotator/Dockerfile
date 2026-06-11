FROM python:3.11-slim as builder

WORKDIR /build
COPY requirements.txt .
RUN pip install --user --no-cache-dir -r requirements.txt

FROM gcr.io/distroless/python3-debian11

COPY --from=builder /root/.local /home/appuser/.local
COPY main.py .

ENV PATH=/home/appuser/.local/bin:$PATH
USER 1001

CMD ["main.py"]
