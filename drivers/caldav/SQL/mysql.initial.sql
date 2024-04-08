/**
 * CalDAV Client
 *
 * @version @package_version@
 * @author Daniel Morlock <daniel.morlock@awesome-it.de>
 * @author JodliDev <jodlidev@gmail.com>
 *
 * Copyright (C) Awesome IT GbR <info@awesome-it.de>
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

CREATE TABLE IF NOT EXISTS `caldav_sources` (
    `source_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0',

    `caldav_url` varchar(1024) NOT NULL,
    `caldav_user` varchar(255) DEFAULT NULL,
    `caldav_pass` varchar(1024) DEFAULT NULL,

    PRIMARY KEY(`source_id`),
    CONSTRAINT `fk_caldav_sources_user_id` FOREIGN KEY (`user_id`)
        REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8 COLLATE utf8_general_ci */;

CREATE TABLE IF NOT EXISTS `caldav_calendars` (
    `calendar_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `user_id` int(10) UNSIGNED NOT NULL DEFAULT '0',
    `source_id` int(10) UNSIGNED DEFAULT NULL,
    `name` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
    `color` varchar(8) NOT NULL,
    `showalarms` tinyint(1) NOT NULL DEFAULT '1',

    `caldav_tag` varchar(255) DEFAULT NULL,
    `caldav_url` varchar(1024) NOT NULL,
    `caldav_last_change` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `is_ical` tinyint(1) NOT NULL DEFAULT '0',
    `ical_user` varchar(255) DEFAULT NULL,
    `ical_pass` varchar(1024) DEFAULT NULL,

    PRIMARY KEY(`calendar_id`),
    INDEX `caldav_user_name_idx` (`user_id`, `name`),
    CONSTRAINT `fk_caldav_calendars_user_id` FOREIGN KEY (`user_id`)
        REFERENCES `users`(`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_caldav_calendars_sources` FOREIGN KEY (`source_id`)
        REFERENCES `caldav_sources`(`source_id`) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

CREATE TABLE IF NOT EXISTS `caldav_events` (
    `event_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `calendar_id` int(11) UNSIGNED NOT NULL DEFAULT '0',
    `recurrence_id` int(11) UNSIGNED NOT NULL DEFAULT '0',
    `uid` varchar(255) NOT NULL DEFAULT '',
    `instance` varchar(16) NOT NULL DEFAULT '',
    `isexception` tinyint(1) NOT NULL DEFAULT '0',
    `created` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
    `changed` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
    `sequence` int(1) UNSIGNED NOT NULL DEFAULT '0',
    `start` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
    `end` datetime NOT NULL DEFAULT '1000-01-01 00:00:00',
    `recurrence` varchar(255) DEFAULT NULL,
    `title` varchar(255) CHARACTER SET utf8mb4 NOT NULL,
    `description` text CHARACTER SET utf8mb4 NOT NULL,
    `location` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
    `categories` varchar(255) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
    `url` varchar(255) NOT NULL DEFAULT '',
    `all_day` tinyint(1) NOT NULL DEFAULT '0',
    `free_busy` tinyint(1) NOT NULL DEFAULT '0',
    `priority` tinyint(1) NOT NULL DEFAULT '0',
    `sensitivity` tinyint(1) NOT NULL DEFAULT '0',
    `status` varchar(32) NOT NULL DEFAULT '',
    `alarms` text NULL DEFAULT NULL,
    `attendees` text DEFAULT NULL,
    `notifyat` datetime DEFAULT NULL,

    `caldav_url` varchar(255) NOT NULL,
    `caldav_tag` varchar(255) DEFAULT NULL,
    `caldav_last_change` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    PRIMARY KEY(`event_id`),
    INDEX `caldav_uid_idx` (`uid`),
    INDEX `caldav_recurrence_idx` (`recurrence_id`),
    INDEX `caldav_calendar_notify_idx` (`calendar_id`,`notifyat`),
    CONSTRAINT `fk_caldav_events_calendar_id` FOREIGN KEY (`calendar_id`)
        REFERENCES `caldav_calendars`(`calendar_id`) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;

CREATE TABLE IF NOT EXISTS `caldav_attachments` (
    `attachment_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
    `event_id` int(11) UNSIGNED NOT NULL DEFAULT '0',
    `filename` varchar(255) NOT NULL DEFAULT '',
    `mimetype` varchar(255) NOT NULL DEFAULT '',
    `size` int(11) NOT NULL DEFAULT '0',
    `data` longtext NOT NULL,
    PRIMARY KEY(`attachment_id`),
    CONSTRAINT `fk_caldav_attachments_event_id` FOREIGN KEY (`event_id`)
        REFERENCES `caldav_events`(`event_id`) ON DELETE CASCADE ON UPDATE CASCADE
) /*!40000 ENGINE=INNODB */ /*!40101 CHARACTER SET utf8 COLLATE utf8_general_ci */;

INSERT INTO `system` (`name`, `value`) VALUES ('calendar-caldav-version', '2021082400');
