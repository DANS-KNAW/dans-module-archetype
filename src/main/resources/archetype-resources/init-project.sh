#!/usr/bin/env bash
#
# Copyright (C) 2017 DANS - Data Archiving and Networked Services (info@dans.knaw.nl)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

START_ENV="start-env.sh"

echo Setting .gitignore...
mv _gitignore .gitignore

echo Making helper scripts executable...
chmod +x *.sh

echo -n "Removing .keep files for empty directories..."
find src/main/java -name .keep -delete
find src/test/java -name .keep -delete
echo "OK"

echo -n "Checking if we can find $START_ENV..."
which "$START_ENV" > /dev/null
if [ $? -eq 0 ]; then
    echo "OK"
    echo "Running $START_ENV..."
    eval $START_ENV
    if [ $? -eq 0 ]; then
      echo "$START_ENV: OK"
    else
      echo "$START_ENV: FAILED"
    fi
else
    echo "NOT FOUND. Ignoring."
fi

#
# Building is the last thing we do. Somehow bash sometimes skips over the next few characters after the
# mvn invocation. When it then tries to execute the next line starting from the 4th or 5th char it
# runs into what it thinks to be an unkown command, or, if the skipped chars contained a double quote,
# at the end of the script bash looks for the closing one and signals a syntax error.
#
echo Building...
mvn generate-sources license:format install
