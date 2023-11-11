from setuptools import setup

APP=['main.py']
OPTIONS = {
    'iconfile':'icon.png',
    'argv_emulation': True,
}

setup(
    app=APP,
    options={'py2app': OPTIONS},
    setup_requires=['py2app']
)

#MacOS Command: pip install py2app
#               python setup.py py2app -A
