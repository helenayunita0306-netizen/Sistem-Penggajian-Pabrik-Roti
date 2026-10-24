/* Isi SUPABASE_URL dan SUPABASE_ANON_KEY milik proyek Anda. Jangan pernah menaruh service_role key di browser. */
const SUPABASE_URL = 'https://psstpphkpdgihdvmandn.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBzc3RwcGhrcGRnaWhkdm1hbmRuIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTI4Mzk1MDUsImV4cCI6MjEwODQxNTUwNX0.HyKkx7YJgZxdkEXzx35ZKmiGej1ATwznCpUQdzi6bNU';

const Supa = (() => {
  const configured = () => typeof window.supabase !== 'undefined' && SUPABASE_URL.startsWith('https://') && !SUPABASE_URL.includes('ISI_URL') && SUPABASE_ANON_KEY.length > 20 && !SUPABASE_ANON_KEY.includes('ISI_ANON');
  let client = null;
  function getClient() {
    if (!configured()) throw new Error('Konfigurasi Supabase belum diisi. Buka supabase-config.js lalu isi URL dan anon/publishable key.');
    if (!client) client = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY, {auth:{persistSession:true,autoRefreshToken:true,detectSessionInUrl:true}});
    return client;
  }
  async function query(table, action, payload, options={}) {
    const db = getClient(); let q;
    if (action === 'select') { q = db.from(table).select(options.select || '*'); if(options.order) q=q.order(options.order,{ascending:options.ascending ?? false}); if(options.filters) for(const [k,v] of Object.entries(options.filters)) q=q.eq(k,v); if(options.gte) q=q.gte(options.gte[0],options.gte[1]); if(options.lt) q=q.lt(options.lt[0],options.lt[1]); if(options.limit) q=q.limit(options.limit); }
    else if(action==='insert') q=db.from(table).insert(payload).select().single();
    else if(action==='update') q=db.from(table).update(payload).eq('id',options.id).select().single();
    else if(action==='delete') q=db.from(table).delete().eq('id',options.id);
    else throw new Error('Operasi database tidak dikenal.');
    const {data,error}=await q; if(error) throw new Error(error.message); return data;
  }

  /* --- Settings helpers ---
   * Tabel payroll_settings menyimpan data sebagai key-value JSONB.
   * Dua baris yang digunakan: setting_key='company' dan setting_key='payroll_policy'.
   * settingsGet() mengembalikan plain object { company, payroll_policy } untuk kemudahan konsumsi di app.js.
   * settingsUpsert(key, value) menyimpan/memperbarui satu baris berdasarkan setting_key.
   */
  async function settingsGet() {
    const db = getClient();
    const { data, error } = await db.from('payroll_settings').select('setting_key,setting_value');
    if (error) throw new Error(error.message);
    const map = {};
    (data || []).forEach(row => { map[row.setting_key] = row.setting_value; });
    return map;
  }
  async function settingsUpsert(key, value, description) {
    const db = getClient();
    const { error } = await db.from('payroll_settings').upsert(
      { setting_key: key, setting_value: value, description, updated_at: new Date().toISOString() },
      { onConflict: 'setting_key' }
    );
    if (error) throw new Error(error.message);
  }

  const api = {
    isConfigured: configured,
    getClient,
    signIn: async(email,password)=>{const {data,error}=await getClient().auth.signInWithPassword({email,password});if(error)throw error;return data;},
    signOut: async()=>{const {error}=await getClient().auth.signOut();if(error)throw error;},
    getSession: async()=>{const {data,error}=await getClient().auth.getSession();if(error)throw error;return data.session;},
    employees: {all:()=>query('employees','select',null,{order:'full_name',ascending:true}),save:(row,id)=>id?query('employees','update',row,{id}):query('employees','insert',row),remove:id=>query('employees','delete',null,{id})},
    attendance: {all:()=>query('attendance','select',null,{order:'attendance_date'}),save:(row,id)=>id?query('attendance','update',row,{id}):query('attendance','insert',row),remove:id=>query('attendance','delete',null,{id})},
    production: {all:()=>query('production_records','select',null,{order:'production_date'}),save:(row,id)=>id?query('production_records','update',row,{id}):query('production_records','insert',row),remove:id=>query('production_records','delete',null,{id})},
    /* FIX: products API sebelumnya tidak ada — menyebabkan refreshSupabase() throw "Cannot read properties of undefined" */
    products: {all:()=>query('products','select',null,{order:'product_name',ascending:true}),save:(row,id)=>id?query('products','update',row,{id}):query('products','insert',row),remove:id=>query('products','delete',null,{id})},
    payrolls: {all:()=>query('payrolls','select',null,{order:'period_month'}),save:(row,id)=>id?query('payrolls','update',row,{id}):query('payrolls','insert',row),remove:id=>query('payrolls','delete',null,{id})},
    /* FIX: settings kini menggunakan settingsGet/settingsUpsert yang sesuai dengan struktur key-value tabel payroll_settings */
    settings: { get: settingsGet, upsert: settingsUpsert },
  };
  return api;
})();
