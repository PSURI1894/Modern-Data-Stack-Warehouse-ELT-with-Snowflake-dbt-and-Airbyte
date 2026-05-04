from dagster import ScheduleDefinition
from .assets.reverse_etl import hightouch_crm_sync

# Hourly data processing loop schedule
schedules = [
    ScheduleDefinition(
        name="hourly_elt_pipeline",
        cron_schedule="0 * * * *",
        target=hightouch_crm_sync
    )
]
