FROM python:3.11-slim

WORKDIR /app

RUN pip install --no-cache-dir \
	streamlit \
	pandas \
	psycopg2-binary \
	sqlalchemy \
	plotly \
	scikit-learn

COPY . .

CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
