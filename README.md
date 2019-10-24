# backend_django_api

### Purpose of this repo

    The following repo has the purpose to integrate a Docker image with Django (multiple apps), GitHub and Travis. 

    In the Dockerfile, I had to create a separate folder for the new application core.

    The standard is to have the db.sqlite3 and manage.py at the same level of the Dockerfile but I did some changes to prove this new folder structure is possible as well. 
backend_django_api 
    | Dockerfile
    | docker-compose.yml
    | Pipfile
    | Pipfile.lock
    | README.md
    | src -------| db.sqlite3
                 | manage.py
                 | app ------------------| __init__.py
                                         | urls.py
                                         | wsgi.py 
                                         | settings.py ---------| base.py
                                                                | __init__.py
                                                                | local.py
                                                                | production.py

                 | core -----------------| __init__.py
                                         | admin.py
                                         | apps.py
                                         | models.py 
                                         | migrations
                                         | tests  -------------| __init__.py
                                                               | test_admin.py
                                                               | test_models.py




### 1. Modify the `settings.py`.

        
     Modify `ROOT_URLCONF = 'app.urls'` to `ROOT_URLCONF = 'src.app.urls'` because of the way the file structure was setup. 

     <b>If you upload this image to Heroku, you have to put back the original configuration as `app.urls` from inside of the container. </b>


### 2. Modify the `wsgi.py`.

    Modify `os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'app.settings')`  to `os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'src.app.settings')`


### 3. Modify the `Dockerfile`

    Modify `CMD gunicorn app.wsgi:application --bind 0.0.0.0:$PORT` to `CMD gunicorn src.app.wsgi:application --bind 0.0.0.0:$PORT`

1. `base.py` is the original file settings.py
2. `local.py` is the modified file version for development. Docker won't work here.
3. `production.py` is the modified file version for docker in production.

I have created a folder called settings that divides the scope of the app to be executed in Docker.

## Running Django in Docker (Production)

When running Django in Docker you need to make sure that the `manage.py` and `wsgi.py` files contain the following lines:

    `manage.py`
        `os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'app.settings.production')`

    `wsgi.py`
        `os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'src.app.settings.production')`

After this, you must execute your dockerized app with the command `gunicorn src.app.wsgi:application --bind 0.0.0.0:8888` in the same level as the Dockerfile.


## Running Django in Docker (Development)

When running Django in Docker you need to make sure that the `manage.py` and `wsgi.py` files contain the following lines:

    `manage.py`
        `os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'app.settings.local')`

    `wsgi.py`
        `os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'src.app.settings.local')`

After this, you can execute normally your python app with `python3 manage.py runserver` in the same level as in the `manage.py` file.

If you deploy this image in a container, you will have to change the line `src.djangodocker.urls` from the `settings.py` to `djangodocker.urls` within the container. 

    `heroku run bash -a djangodocker`
    `cd src`
    `python3 manage.py makemigrations`

