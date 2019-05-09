echo "Initializing MySQL..."
mysql_connection_max_attempts=10
mysql_connection_attempt=0
until mysql -u root --password="{{ MYSQL_ROOT_PASSWORD }}" --host "{{ MYSQL_HOST }}" --port {{ MYSQL_PORT }} -e 'exit'
do
    mysql_connection_attempt=$(expr $mysql_connection_attempt + 1)
    echo "    [$mysql_connection_attempt/$mysql_connection_max_attempts] Waiting for MySQL service (this may take a while)..."
    if [ $mysql_connection_attempt -eq $mysql_connection_max_attempts ]
    then
      echo "MySQL initialization error" 1>&2
      exit 1
    fi
    sleep 10
done
echo "MySQL is up and running"

mysql -u root --password="{{ MYSQL_ROOT_PASSWORD }}" --host "{{ MYSQL_HOST }}" --port {{ MYSQL_PORT }} -e 'CREATE DATABASE IF NOT EXISTS {{ OPENEDX_MYSQL_DATABASE }};'
mysql -u root --password="{{ MYSQL_ROOT_PASSWORD }}" --host "{{ MYSQL_HOST }}" --port {{ MYSQL_PORT }} -e 'GRANT ALL ON {{ OPENEDX_MYSQL_DATABASE }}.* TO "{{ OPENEDX_MYSQL_USERNAME }}"@"%" IDENTIFIED BY "{{ OPENEDX_MYSQL_PASSWORD }}";'

{% if ACTIVATE_NOTES %}
mysql -u root --password="{{ MYSQL_ROOT_PASSWORD }}" --host "{{ MYSQL_HOST }}" --port {{ MYSQL_PORT }} -e 'CREATE DATABASE IF NOT EXISTS {{ NOTES_MYSQL_DATABASE }};'
mysql -u root --password="{{ MYSQL_ROOT_PASSWORD }}" --host "{{ MYSQL_HOST }}" --port {{ MYSQL_PORT }} -e 'GRANT ALL ON {{ NOTES_MYSQL_DATABASE }}.* TO "{{ NOTES_MYSQL_USERNAME }}"@"%" IDENTIFIED BY "{{ NOTES_MYSQL_PASSWORD }}";'
{% endif %}

{% if ACTIVATE_XQUEUE %}
mysql -u root --password="{{ MYSQL_ROOT_PASSWORD }}" --host "{{ MYSQL_HOST }}" --port {{ MYSQL_PORT }} -e 'CREATE DATABASE IF NOT EXISTS {{ XQUEUE_MYSQL_DATABASE }};'
mysql -u root --password="{{ MYSQL_ROOT_PASSWORD }}" --host "{{ MYSQL_HOST }}" --port {{ MYSQL_PORT }} -e 'GRANT ALL ON {{ XQUEUE_MYSQL_DATABASE }}.* TO "{{ XQUEUE_MYSQL_USERNAME }}"@"%" IDENTIFIED BY "{{ XQUEUE_MYSQL_PASSWORD }}";'
{% endif %}
