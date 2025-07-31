#!/usr/bin/env python3
import os
import re
import subprocess
from datetime import datetime
from pathlib import Path

def get_file_last_modified(file_path):
    """Get the last modified date of a file from Git."""
    try:
        # Get the last commit date for the file
        result = subprocess.run(
            ['git', 'log', '-1', '--format=%ad', '--date=format:%Y-%m-%d %H:%M:%S', '--', file_path],
            capture_output=True, text=True, check=True
        )
        if result.stdout.strip():
            return datetime.strptime(result.stdout.strip(), '%Y-%m-%d %H:%M:%S')
    except subprocess.CalledProcessError:
        pass
    
    # Fallback to file system modified time
    return datetime.fromtimestamp(os.path.getmtime(file_path))

def find_markdown_files(root_dir):
    """Find all markdown files in the repository, excluding README.md."""
    md_files = []
    
    for root, dirs, files in os.walk(root_dir):
        # Skip hidden directories and common build/dependency directories
        dirs[:] = [d for d in dirs if not d.startswith('.') and d not in ['node_modules', 'build', 'dist']]
        
        for file in files:
            if file.endswith('.md') and file.lower() != 'readme.md':
                file_path = os.path.join(root, file)
                rel_path = os.path.relpath(file_path, root_dir)
                last_modified = get_file_last_modified(file_path)
                md_files.append((rel_path, last_modified))
    
    # Sort by last modified date (most recent first)
    md_files.sort(key=lambda x: x[1], reverse=True)
    return md_files

def format_date(date):
    """Format date in a nice, readable way."""
    now = datetime.now()
    diff = now - date
    
    if diff.days == 0:
        return "Today"
    elif diff.days == 1:
        return "Yesterday"
    elif diff.days < 7:
        return f"{diff.days} days ago"
    elif diff.days < 30:
        weeks = diff.days // 7
        return f"{weeks} week{'s' if weeks > 1 else ''} ago"
    elif diff.days < 365:
        months = diff.days // 30
        return f"{months} month{'s' if months > 1 else ''} ago"
    else:
        return date.strftime("%B %d, %Y")

def update_readme(root_dir):
    """Update README.md with a list of markdown files."""
    readme_path = os.path.join(root_dir, 'README.md')
    
    # Read current README content
    with open(readme_path, 'r') as f:
        content = f.read()
    
    # Find markdown files
    md_files = find_markdown_files(root_dir)
    
    # Generate the markdown list
    md_list = "\n## Markdown Files in This Repository\n\n"
    
    if md_files:
        md_list += "| File | Last Modified |\n"
        md_list += "|------|---------------|\n"
        
        for file_path, last_modified in md_files:
            formatted_date = format_date(last_modified)
            # Make file path a link
            md_list += f"| [{file_path}]({file_path.replace(' ', '%20')}) | {formatted_date} |\n"
    else:
        md_list += "_No markdown files found in this repository (excluding README.md)._\n"
    
    md_list += "\n_Last updated: " + datetime.now().strftime("%Y-%m-%d %H:%M:%S UTC") + "_\n"
    
    # Define markers for the section
    start_marker = "<!-- MARKDOWN_FILES_START -->"
    end_marker = "<!-- MARKDOWN_FILES_END -->"
    
    # Check if markers exist in README
    if start_marker in content and end_marker in content:
        # Replace content between markers
        pattern = re.compile(f"{re.escape(start_marker)}.*?{re.escape(end_marker)}", re.DOTALL)
        new_content = pattern.sub(f"{start_marker}\n{md_list}\n{end_marker}", content)
    else:
        # Add markers and content at the end
        new_content = content.rstrip() + "\n\n" + start_marker + "\n" + md_list + "\n" + end_marker + "\n"
    
    # Write updated content
    with open(readme_path, 'w') as f:
        f.write(new_content)
    
    print(f"README.md updated successfully with {len(md_files)} markdown file(s).")

if __name__ == "__main__":
    # Get the repository root (where the script is called from)
    repo_root = os.getcwd()
    update_readme(repo_root)