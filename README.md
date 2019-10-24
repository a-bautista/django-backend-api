# backend_django_api

In the Dockerfile, I had to create a separate folder for the new application core.

I have created a folder called settings that divides the scope of the app to be executed in Docker.

1. `base.py` is the original file settings.py
2. `local.py` is the modified file version for development. Docker won't work here.
3. `production.py` is the modified file version for docker in production.

## Running Django in Docker (Production)

When running Django in Docker you need to make sure that the `manage.py` and `wsgi.py` files contain the following lines:

    `manage.py`
        `os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'app.settings.production')`

    `wsgi.py`
        `os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'src.app.settings.production')`

After this, you must execute your dockerized app with the command `gunicorn src.app.wsgi:application --bind 0.0.0.0:8888`
in the same level as the Dockerfile.


## Running Django in Docker (Development)

When running Django in Docker you need to make sure that the `manage.py` and `wsgi.py` files contain the following lines:

    `manage.py`
        `os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'app.settings.local')`

    `wsgi.py`
        `os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'src.app.settings.local')`

After this, you can execute normally your python app with `python3 manage.py runserver` in the same level as in
the `manage.py` file.

