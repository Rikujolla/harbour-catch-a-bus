# NOTICE:
#
# Application name defined in TARGET has a corresponding QML filename.
# If name defined in TARGET is changed, the following needs to be done
# to match new name:
#   - corresponding QML filename must be changed
#   - desktop icon filename must be changed
#   - desktop filename must be changed
#   - icon definition filename in desktop file must be changed
#   - translation filenames have to be changed

# The name of your application
TARGET = harbour-catch-a-bus

CONFIG += sailfishapp_qml

SOURCES +=

OTHER_FILES += \
    harbour-catch-a-bus.desktop \
    qml/cover/CoverPage.qml \
    qml/harbour-catch-a-bus.qml \
    qml/pages/FirstPage.qml \
    rpm/harbour-catch-a-bus.changes \
    rpm/harbour-catch-a-bus.spec \
    rpm/harbour-catch-a-bus.yaml \
    qml/cover/coveractions.py \
    qml/pages/datadownloader.py

DISTFILES += \
    qml/pages/About.qml \
    qml/pages/Busses.qml \
    qml/pages/LoadStatic.qml \
    qml/pages/Settings.qml \
    qml/pages/Stops.qml \
    qml/pages/dbfunctions.js \
    qml/pages/functions.js
