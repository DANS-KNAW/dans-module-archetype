#!/usr/bin/env bash
#
# Copyright (C) 2022 DANS - Data Archiving and Networked Services (info@dans.knaw.nl)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


DEFAULT_ARCHETYPE_VERSION=0.0.1-SNAPSHOT

read -p "dans-module-archetype version? (default = $DEFAULT_ARCHETYPE_VERSION): " ARCHETYPE_VERSION
read -p "Module artifactId: " ARTIFACT_ID
read -p "Name module's main package (i.e. the one UNDER nl.knaw.dans): " SUBPACKAGE
read -p "Description (one to four sentences): " DESCRIPTION

ARTIFACT_PHRASE=`echo $ARTIFACT_ID | tr '-' ' ' | awk '{for (i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)} 1'`
MODULE_JAVA_NAME=${ARTIFACT_PHRASE// }

mvn archetype:generate -DarchetypeGroupId=nl.knaw.dans \
        -DarchetypeArtifactId=dans-module-archetype \
        -DarchetypeVersion=${ARCHETYPE_VERSION:-"$DEFAULT_ARCHETYPE_VERSION"} \
        -DgroupId=nl.knaw.dans \
        -DartifactId=$ARTIFACT_ID \
        -Dpackage=nl.knaw.dans.$SUBPACKAGE \
        -DmoduleSubpackage=$SUBPACKAGE \
        -DprojectName="$ARTIFACT_PHRASE" \
        -DjavaName="$MODULE_JAVA_NAME" \
        -Ddescription="$DESCRIPTION" \
        -DinceptionYear=$(date +"%Y")

pushd $ARTIFACT_ID
bash init-project.sh
rm init-project.sh
popd
