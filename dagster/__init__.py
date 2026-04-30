# Standard Dagster Initialization
from dagster import Definitions, load_assets_from_modules

from .assets import airbyte_syncs, dbt_models, reverse_etl
from .schedules import schedules
from .sensors import sensors

all_assets = load_assets_from_modules([airbyte_syncs, dbt_models, reverse_etl])

defs = Definitions(
    assets=all_assets,
    schedules=schedules,
    sensors=sensors,
)
