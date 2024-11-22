/**
 * CalDAV Client
 * (not tested & automatically generated from mysql)
 *
 * @version @package_version@
 * @author JodliDev <jodlidev@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

-- SQLINES LICENSE FOR EVALUATION USE ONLY
CREATE SEQUENCE IF NOT EXISTS caldav_sources_seq;

CREATE TABLE IF NOT EXISTS caldav_sources (
                                              source_id int CHECK (source_id > 0) NOT NULL DEFAULT NEXTVAL ('caldav_sources_seq'),
    user_id int CHECK (user_id > 0) NOT NULL DEFAULT '0',

    caldav_url varchar(1024) NOT NULL,
    caldav_user varchar(255) DEFAULT NULL,
    caldav_pass varchar(1024) DEFAULT NULL,

    PRIMARY KEY(source_id),
    CONSTRAINT fk_caldav_sources_user_id FOREIGN KEY (user_id)
    REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE
    ) /* SQLINES DEMO *** DB */ /* SQLINES DEMO *** ET utf8 COLLATE utf8_general_ci */;

-- SQLINES LICENSE FOR EVALUATION USE ONLY
CREATE SEQUENCE IF NOT EXISTS caldav_calendars_seq;

CREATE TABLE IF NOT EXISTS caldav_calendars (
                                                calendar_id int CHECK (calendar_id > 0) NOT NULL DEFAULT NEXTVAL ('caldav_calendars_seq'),
    user_id int CHECK (user_id > 0) NOT NULL DEFAULT '0',
    source_id int CHECK (source_id > 0) DEFAULT NULL,
    name varchar(255) NOT NULL,
    color varchar(8) NOT NULL,
    showalarms smallint NOT NULL DEFAULT '1',

    caldav_tag varchar(255) DEFAULT NULL,
    caldav_url varchar(1024) NOT NULL,
    caldav_last_change timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_ical smallint NOT NULL DEFAULT '0',
    ical_user varchar(255) DEFAULT NULL,
    ical_pass varchar(1024) DEFAULT NULL,

    PRIMARY KEY(calendar_id)
    ,
    CONSTRAINT fk_caldav_calendars_user_id FOREIGN KEY (user_id)
    REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_caldav_calendars_sources FOREIGN KEY (source_id)
    REFERENCES caldav_sources(source_id) ON DELETE CASCADE ON UPDATE CASCADE
    ) /* SQLINES DEMO *** DB */ /* SQLINES DEMO *** ET utf8 COLLATE utf8_general_ci */;

CREATE INDEX IF NOT EXISTS caldav_user_name_idx ON caldav_calendars (user_id, name);

-- SQLINES LICENSE FOR EVALUATION USE ONLY
CREATE SEQUENCE IF NOT EXISTS caldav_events_seq;

CREATE TABLE IF NOT EXISTS caldav_events (
    event_id int CHECK (event_id > 0) NOT NULL DEFAULT NEXTVAL ('caldav_events_seq'),
    calendar_id int CHECK (calendar_id > 0) NOT NULL DEFAULT '0',
    recurrence_id int NOT NULL DEFAULT '0',
    uid varchar(255) NOT NULL DEFAULT '',
    instance varchar(16) NOT NULL DEFAULT '',
    isexception smallint NOT NULL DEFAULT '0',
    created timestamp(0) NOT NULL DEFAULT '1000-01-01 00:00:00',
    changed timestamp(0) NOT NULL DEFAULT '1000-01-01 00:00:00',
    sequence int NOT NULL DEFAULT '0',
    start timestamp(0) NOT NULL DEFAULT '1000-01-01 00:00:00',
    "end" timestamp(0) NOT NULL DEFAULT '1000-01-01 00:00:00',
    recurrence varchar(255) DEFAULT NULL,
    title varchar(255) NOT NULL,
    description text NOT NULL,
    location varchar(255) NOT NULL DEFAULT '',
    categories varchar(255) NOT NULL DEFAULT '',
    url varchar(255) NOT NULL DEFAULT '',
    all_day smallint NOT NULL DEFAULT '0',
    free_busy smallint NOT NULL DEFAULT '0',
    priority smallint NOT NULL DEFAULT '0',
    sensitivity smallint NOT NULL DEFAULT '0',
    status varchar(32) NOT NULL DEFAULT '',
    alarms text NULL DEFAULT NULL,
    attendees text DEFAULT NULL,
    notifyat timestamp(0) DEFAULT NULL,

    caldav_url varchar(255) NOT NULL,
    caldav_tag varchar(255) DEFAULT NULL,
    caldav_last_change timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY(event_id)
    ,
    CONSTRAINT fk_caldav_events_calendar_id FOREIGN KEY (calendar_id)
    REFERENCES caldav_calendars(calendar_id) ON DELETE CASCADE ON UPDATE CASCADE
    ) /* SQLINES DEMO *** DB */ /* SQLINES DEMO *** ET utf8 COLLATE utf8_general_ci */;

CREATE INDEX IF NOT EXISTS caldav_uid_idx ON caldav_events (uid);
CREATE INDEX IF NOT EXISTS caldav_recurrence_idx ON caldav_events (recurrence_id);
CREATE INDEX IF NOT EXISTS caldav_calendar_notify_idx ON caldav_events (calendar_id,notifyat);

-- SQLINES LICENSE FOR EVALUATION USE ONLY
CREATE SEQUENCE IF NOT EXISTS caldav_attachments_seq;

CREATE TABLE IF NOT EXISTS caldav_attachments (
                                                  attachment_id int CHECK (attachment_id > 0) NOT NULL DEFAULT NEXTVAL ('caldav_attachments_seq'),
    event_id int CHECK (event_id > 0) NOT NULL DEFAULT '0',
    filename varchar(255) NOT NULL DEFAULT '',
    mimetype varchar(255) NOT NULL DEFAULT '',
    size int NOT NULL DEFAULT '0',
    data TEXT NOT NULL,
    PRIMARY KEY(attachment_id),
    CONSTRAINT fk_caldav_attachments_event_id FOREIGN KEY (event_id)
    REFERENCES caldav_events(event_id) ON DELETE CASCADE ON UPDATE CASCADE
    ) /* SQLINES DEMO *** DB */ /* SQLINES DEMO *** ET utf8 COLLATE utf8_general_ci */;

INSERT INTO system (name, value) VALUES ('calendar-caldav-version', '2024112200') ON CONFLICT (name) DO UPDATE SET value = excluded.value;
