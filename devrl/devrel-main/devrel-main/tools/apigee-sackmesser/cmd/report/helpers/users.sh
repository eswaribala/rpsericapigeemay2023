#!/bin/bash

# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# <http://www.apache.org/licenses/LICENSE-2.0>
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

echo "<h3>Users</h3>" >> "$report_html"

mkdir -p "$export_folder/$organization/config/resources/edge/env/$environment/user"

sackmesser list "users"| jq -r -c '.[]|.[]' | while read -r userdetail; do
        email=$(echo "$userdetail" | jq -r '.name')
        sackmesser list "users/$email" > "$export_folder/$organization/config/resources/edge/env/$environment/user/$email".json
    done

if ls "$export_folder/$organization/config/resources/edge/env/$environment/user"/*.json 1> /dev/null 2>&1; then
    jq -n '[inputs]' "$export_folder/$organization/config/resources/edge/env/$environment/user"/*.json > "$export_folder/$organization/config/resources/edge/env/$environment/users".json
fi

echo "<div><table id=\"user-lint\" data-toggle=\"table\" class=\"table\">" >> "$report_html"
echo "<thead class=\"thead-dark\"><tr>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"id\">Email</th>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"firstname\">First Name</th>" >> "$report_html"
echo "<th data-sortable=\"true\" data-field=\"lastname\">Last Name</th>" >> "$report_html"
echo "</tr></thead>" >> "$report_html"

echo "<tbody class=\"mdc-data-table__content\">" >> "$report_html"

if [ -f "$export_folder/$organization/config/resources/edge/env/$environment/users".json ]; then
    jq -c '.[]' "$export_folder/$organization/config/resources/edge/env/$environment/users".json | while read i; do 
        emailId=$(echo "$i" | jq -r '.emailId')
        firstName=$(echo "$i" | jq -r '.firstName')
        lastName=$(echo "$i" | jq -r '.lastName')

        echo "<tr class=\"$highlightclass\">"  >> "$report_html"
        echo "<td>$emailId</td>"  >> "$report_html"
        echo "<td>$firstName</td>" >> "$report_html"
        echo "<td>$lastName</td>" >> "$report_html"
        echo "</tr>"  >> "$report_html"
    done
fi

echo "</tbody></table></div>" >> "$report_html"