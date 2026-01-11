#!/usr/bin/env python3
"""
Looking Ahead Calendar Generator for Velog
==========================================
Generates a Velog-style markdown calendar table for upcoming events.
Outputs to LOOKING_AHEAD.md and can update root README.md

Usage:
    python generate_looking_ahead.py [--weeks N] [--update-readme]

Options:
    --weeks N        Number of weeks to look ahead (default: 8)
    --update-readme  Update the root README.md file
"""

import json
import os
from datetime import datetime, timedelta
from pathlib import Path
import argparse
import re


def load_events_data(json_path: str = "events_data.json") -> dict:
    """Load events data from JSON file."""
    script_dir = Path(__file__).parent
    json_file = script_dir / json_path
    
    with open(json_file, 'r', encoding='utf-8') as f:
        return json.load(f)


def get_flag(country_code: str, flags: dict) -> str:
    """Get country flag emoji from country code."""
    return flags.get(country_code, "🌍")


def parse_date_range(date_str: str) -> tuple:
    """Parse date string and return (start_date, end_date, is_range)."""
    # Handle special cases like "2026년 초"
    if "년" in date_str and ("초" in date_str or "중" in date_str or "말" in date_str):
        return None, None, False
    
    # Handle date ranges like "2026-01-06~09" or "2026-04-26~05-01"
    if "~" in date_str:
        parts = date_str.split("~")
        start_str = parts[0].strip()
        end_str = parts[1].strip()
        
        try:
            start_date = datetime.strptime(start_str, "%Y-%m-%d")
            
            # End might be just day or month-day
            if "-" in end_str and len(end_str) > 2:
                # Format: MM-DD or full date
                if len(end_str) <= 5:  # MM-DD
                    end_date = datetime.strptime(f"{start_date.year}-{end_str}", "%Y-%m-%d")
                else:
                    end_date = datetime.strptime(end_str, "%Y-%m-%d")
            else:
                # Just day number
                end_date = start_date.replace(day=int(end_str))
            
            return start_date, end_date, True
        except ValueError:
            return None, None, False
    
    # Single date
    try:
        single_date = datetime.strptime(date_str, "%Y-%m-%d")
        return single_date, single_date, False
    except ValueError:
        return None, None, False


def filter_upcoming_events(events: list, flags: dict, weeks_ahead: int = 8) -> list:
    """Filter events within the specified weeks ahead from today."""
    today = datetime.now()
    cutoff_date = today + timedelta(weeks=weeks_ahead)
    
    upcoming = []
    
    for event in events:
        start_date, end_date, is_range = parse_date_range(event["date"])
        
        # Include events with unparseable dates (like "2026년 초") if within general timeframe
        if start_date is None:
            # For special dates, include if they seem to be in the near future
            if "2026" in event["date"]:
                upcoming.append(event)
            continue
        
        # Check if event is upcoming (within range)
        if start_date <= cutoff_date and (end_date is None or end_date >= today):
            upcoming.append(event)
    
    return upcoming


def sort_events_by_date(events: list) -> list:
    """Sort events by start date."""
    def get_sort_key(event):
        start_date, _, _ = parse_date_range(event["date"])
        if start_date:
            return start_date
        # Put unparseable dates at the end
        return datetime.max
    
    return sorted(events, key=get_sort_key)


def generate_table(events: list, flags: dict, title: str) -> str:
    """Generate markdown table for events."""
    if not events:
        return ""
    
    lines = [
        f"**{title}**",
        "| 일자 | 행사명 | 장소 | 주요 내용 |",
        "|:----:|:------:|:----:|:---------|"
    ]
    
    for event in events:
        flag = get_flag(event["location"], flags)
        city = event["city"]
        
        # Format location with subscript-style country code
        location = f"<sub>{event['location']}</sub> {city}"
        
        lines.append(
            f"| {event['date']} | **{event['name']}** | {location} | {event['description']} |"
        )
    
    return "\n".join(lines)


def generate_looking_ahead(data: dict, weeks_ahead: int = 8) -> str:
    """Generate the complete Looking Ahead markdown content."""
    flags = data.get("country_flags", {})
    
    # Filter and sort events for each category
    domestic = sort_events_by_date(
        filter_upcoming_events(data.get("domestic", []), flags, weeks_ahead)
    )
    international = sort_events_by_date(
        filter_upcoming_events(data.get("international", []), flags, weeks_ahead)
    )
    academic = sort_events_by_date(
        filter_upcoming_events(data.get("academic", []), flags, weeks_ahead)
    )
    certifications = sort_events_by_date(
        filter_upcoming_events(data.get("certifications", []), flags, weeks_ahead)
    )
    
    sections = ["### Looking Ahead", ""]
    
    # Add domestic events
    if domestic:
        sections.append(generate_table(domestic, flags, "국내 행사"))
        sections.append("")
    
    # Add international events
    if international:
        sections.append(generate_table(international, flags, "대외 행사(현지시간)"))
        sections.append("")
    
    # Add academic events
    if academic:
        sections.append(generate_table(academic, flags, "학술 행사"))
        sections.append("")
    
    # Add certification exams
    if certifications:
        sections.append(generate_table(certifications, flags, "자격시험 일정"))
        sections.append("")
    
    # Add generation timestamp
    sections.append(f"> 마지막 업데이트: {datetime.now().strftime('%Y-%m-%d %H:%M')}")
    
    return "\n".join(sections)


def update_readme(readme_path: str, new_content: str, marker_start: str = "<!-- LOOKING_AHEAD_START -->", marker_end: str = "<!-- LOOKING_AHEAD_END -->"):
    """Update README.md with new Looking Ahead content between markers."""
    readme_file = Path(readme_path)
    
    if not readme_file.exists():
        print(f"README not found at {readme_path}")
        return False
    
    with open(readme_file, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Check if markers exist
    if marker_start in content and marker_end in content:
        # Replace content between markers
        pattern = f"{re.escape(marker_start)}.*?{re.escape(marker_end)}"
        replacement = f"{marker_start}\n{new_content}\n{marker_end}"
        new_readme = re.sub(pattern, replacement, content, flags=re.DOTALL)
    else:
        # Add markers and content at the end of the file
        new_readme = content + f"\n\n{marker_start}\n{new_content}\n{marker_end}\n"
    
    with open(readme_file, 'w', encoding='utf-8') as f:
        f.write(new_readme)
    
    print(f"Updated {readme_path}")
    return True


def main():
    parser = argparse.ArgumentParser(description="Generate Looking Ahead calendar for Velog")
    parser.add_argument("--weeks", type=int, default=8, help="Number of weeks to look ahead")
    parser.add_argument("--update-velog", action="store_true", help="Update velog_calendar.md")
    parser.add_argument("--all-events", action="store_true", help="Show all events regardless of date")
    args = parser.parse_args()
    
    # Load data
    data = load_events_data()
    
    # Generate content
    if args.all_events:
        # Show all events (useful for full calendar view)
        weeks = 52 * 2  # 2 years
    else:
        weeks = args.weeks
    
    content = generate_looking_ahead(data, weeks)
    
    # Save to LOOKING_AHEAD.md in calendar folder
    script_dir = Path(__file__).parent
    output_file = script_dir / "LOOKING_AHEAD.md"
    
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"Generated {output_file}")
    
    # Update velog_calendar.md if requested
    if args.update_velog:
        velog_file = script_dir / "velog_calendar.md"
        update_readme(str(velog_file), content)
    
    # Print preview
    print("\n" + "="*50)
    print("Preview:")
    print("="*50)
    print(content)


if __name__ == "__main__":
    main()
