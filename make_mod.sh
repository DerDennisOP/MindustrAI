# Zip all files in frontend
cd frontend
./gradlew jar
cd ..
rm -f config/mods/mindustrai.jar
cp frontend/build/libs/mindustrai.jar config/mods/mindustrai.jar
