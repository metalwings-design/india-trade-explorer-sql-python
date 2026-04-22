import pandas as pd
import matplotlib.pyplot as plt

# Load data
df = pd.read_csv(r'C:\Users\user\Documents\freelance\independent_projects\trade_sql_project\results\ind trade bal.csv')

# Create bar plot
plt.figure(figsize=(12, 6))

# Bar positions
x = df['year']
width = 0.25

# Create bars
plt.bar(x - width, df['total_exports'], width, label='Exports', color='green')
plt.bar(x, df['total_imports'], width, label='Imports', color='red')
plt.bar(x + width, df['trade_balance'], width, label='Trade Balance', color='blue')

# Labels and title
plt.xlabel('Year')
plt.ylabel('Value (Million USD)')
plt.title('India: Exports, Imports and Trade Balance (2018-2025)')
plt.legend()
plt.grid(True, alpha=0.3)

# Show plot
plt.tight_layout()
plt.show()




import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Load the data
df = pd.read_csv(r'C:\Users\user\Documents\freelance\independent_projects\trade_sql_project\results\10 high taariff nations 23.csv')

# Create visualization
fig, ax = plt.subplots(figsize=(12, 8))

# Create horizontal bar chart
bars = ax.barh(range(len(df)), df['tariff_rate_percent'], color='coral', edgecolor='darkred', linewidth=0.5)

# Set y-axis labels to show only country names (without product category)
ax.set_yticks(range(len(df)))
ax.set_yticklabels(df['country'])
ax.set_ylabel('Country', fontsize=12)
ax.set_xlabel('Tariff Rate (%)', fontsize=12)
ax.set_title('Top 10 Highest Tariff Nations & Commodities (2023)', fontsize=14, fontweight='bold')

# Invert y-axis to show highest at top
ax.invert_yaxis()

# Add product category labels ON the bars
for i, (bar, rate, category, country) in enumerate(zip(bars, df['tariff_rate_percent'], df['product_category'], df['country'])):
    # Truncate long category names
    if len(category) > 35:
        category = category[:32] + "..."
    
    # Position text inside the bar (if bar is wide enough) or just outside
    if rate > 15:  # If bar is wide enough, place inside
        ax.text(rate - 2, bar.get_y() + bar.get_height()/2, 
                f'{category}', 
                va='center', ha='right', fontsize=9, color='white', fontweight='bold')
        # Add tariff rate at the end of bar
        ax.text(rate + 0.5, bar.get_y() + bar.get_height()/2, 
                f'{rate:.1f}%', 
                va='center', ha='left', fontsize=10, fontweight='bold', color='darkred')
    else:  # If bar is narrow, place outside
        ax.text(rate + 0.5, bar.get_y() + bar.get_height()/2, 
                f'{category} - {rate:.1f}%', 
                va='center', ha='left', fontsize=9, fontweight='bold', color='darkred')

# Add grid for better readability
ax.grid(axis='x', alpha=0.3, linestyle='--')

# Adjust layout
plt.tight_layout()

# Save the figure
plt.savefig('plots/top_10_tariff_nations.png', dpi=300, bbox_inches='tight')
plt.show()



import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

df = pd.read_csv(r'C:\Users\user\Documents\freelance\independent_projects\trade_sql_project\results\container_vol.csv')
df.columns
# Plot
plt.figure(figsize=(12, 6))
plt.plot(df['year'], df['india_volume'], marker='o', linewidth=2, label='India')
plt.plot(df['year'], df['china_volume'], marker='s', linewidth=2, label='China')
plt.xlabel('Year')
plt.ylabel('Volume (TEU)')
plt.title('Container Port Traffic: India vs China (2010-2024)')
plt.legend()
plt.grid(True, alpha=0.3)
plt.tight_layout()
plt.show()



import pandas as pd
import matplotlib.pyplot as plt

# Option 2: Double backslashes
df = pd.read_csv('C:\\Users\\user\\Documents\\freelance\\independent_projects\\trade_sql_project\\results\\ind_ex_23.csv')
print(df.columns)
plt.figure(figsize=(12, 8))
plt.barh(df['commodity'], df['exports_million_usd_2023'], color='steelblue')
plt.xlabel('Exports (Million USD)')
plt.title('India\'s Top 10 Export Products (2023)')
plt.gca().invert_yaxis()
plt.tight_layout()
plt.show()


import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv(r'C:\Users\user\Documents\freelance\independent_projects\trade_sql_project\results\ind_imp_23.csv')

plt.figure(figsize=(12, 8))
plt.barh(df['commodity'], df['imports_million_usd_2023'], color='coral')
plt.xlabel('Imports (Million USD)')
plt.title('India\'s Top 10 Import Products (2023)')
plt.gca().invert_yaxis()
plt.tight_layout()
plt.savefig('plots/top_10_imports_2023.png', dpi=300)
plt.show()