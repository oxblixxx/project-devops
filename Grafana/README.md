# 🔧 Zabbix + Grafana Troubleshooting Guide  

## 1. Total CPU Cores Not Showing in Grafana  
**Problem:** CPU core count panel in Grafana shows blank or no value.  

**Fix:**  
1. In Grafana, edit the panel → change **Visualization** to **Stat**.  
2. Under **Stat → Calculation**, select **Last (not null)**.  
   - This forces Grafana to always display the latest stored value.  
3. In **Panel → Query options → Relative time**, set a larger window (e.g., `30d`).  
   - Ensures Grafana looks back far enough to find CPU count even if main dashboard is `15m`.  

✅ **Result:** CPU cores display consistently without disappearing.  

---

## 2. Logged-in Users on Windows Not Showing in Grafana  
**Problem:** Windows host doesn’t show number of logged-in users in Grafana.  

**Fix:**  
1. Go to **Configuration → Hosts → The Affected Windows host → Items**.  
2. Create a new item:  
   - **Key:** `system.users.num`  
   - **Type:** Zabbix agent  
   - **Value type:** Numeric (unsigned)  
   - **Update interval:** e.g., `60s`  
   - Ensure item is **enabled**.
Basically set key and name, leave everything as default
3. Test the item in Zabbix:  
   - Use **Test item** → confirm it returns a value (e.g., `3`) .
4. Check **Monitoring → Latest data** for the host.  
   - Confirm `system.users.num` appears and updates. Otherwise go back to the host > Item, click on the newly created item, and click on test and execute now. 
5. In **Grafana**, edit the panel → toggle query to the new item.  

✅ **Result:** Logged-in users now display in Grafana in real time.  

---

## 📌 Summary  
- For **metrics that don’t change often** (CPU cores), use **Last (not null)** and adjust panel **Relative time**.  
- For **real-time metrics** (logged-in users), ensure the item exists in Zabbix (`system.users.num`), test it, verify in **Latest data**, then select it in Grafana.  
