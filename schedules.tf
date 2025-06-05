resource "incident_schedule" "releng_schedule" {
  name     = "LF Releng Schedule"
  timezone = "UTC"

  rotations = [
    {
      id   = "releng_rotation"
      name = "Release Engineering Rotation"

      versions = [
        {
          shift_length      = "168h"
          shift_start_day   = "monday"
          shift_start_time  = "00:00"
          handover_start_at = "2025-06-09T00:00:00Z"
          layers            = []
          users = [
            "user:REPLACE_WITH_USER_ID1",
            "user:REPLACE_WITH_USER_ID2",
            "user:REPLACE_WITH_USER_ID3",
            "user:REPLACE_WITH_USER_ID4",
            "user:REPLACE_WITH_USER_ID5"
          ]
        }
      ]
    }
  ]
}

