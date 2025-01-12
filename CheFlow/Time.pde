
class Time
{
  /* FIELDS */

  int year, month, day, hour, minute;

  /* CONSTRUCTOR */

  Time(int y, int mo, int d, int h, int mi)
  {
    year = max(y, 0);
    month = constrain(mo, 1, 12);
    day = constrain(d, 1, days_in_month(month, year));
    hour = constrain(h, 0, 23);
    minute = constrain(mi, 0, 59);
  }

  Time()
  {
    year = year();
    month = month();
    day = day();
    hour = hour();
    minute = minute();
  }

  Time(String time_str) 
  {
    String[] parts = time_str.split(" ");
    String[] dateParts = parts[0].split("-");
    String[] timeParts = parts[1].split(":");

    year = int(dateParts[0]);
    month = int(dateParts[1]);
    day = int(dateParts[2]);
    hour = int(timeParts[0]);
    minute = int(timeParts[1]);
  }

  /* METHODS */

  String get_time_str()
  {
    return year + "-" + nf(month, 2) + "-" + nf(day, 2) + " " + nf(hour, 2) + ":" + nf(minute, 2);
  }

  // implement compareTo method

  int compareTo(Time t)
  {
    if (year != t.year)
    {
      return year - t.year;
    }
    else if (month != t.month)
    {
      return month - t.month;
    }
    else if (day != t.day)
    {
      return day - t.day;
    }
    else if (hour != t.hour)
    {
      return hour - t.hour;
    }
    else
    {
      return minute - t.minute;
    }
  }

}
