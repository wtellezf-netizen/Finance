(() => {
  const CASA_CLARA_REDIRECT_URL = 'https://wtellezf-netizen.github.io/Finance/';
  const config = window.CASA_CLARA_CONFIG || {};
  const configured = Boolean(window.supabase && config.supabaseUrl && config.supabaseAnonKey);
  const client = configured ? window.supabase.createClient(config.supabaseUrl, config.supabaseAnonKey) : null;

  const fail = (error) => ({ data: null, error });

  window.CasaClaraBackend = {
    configured,
    client,
    async getSession() {
      if (!client) return { data: { session: null }, error: null };
      return client.auth.getSession();
    },
    onAuthStateChange(callback) {
      if (!client) return { data: { subscription: { unsubscribe() {} } } };
      return client.auth.onAuthStateChange(callback);
    },
    async signIn(email, password) {
      if (!client) return fail(new Error('Supabase no está configurado.'));
      return client.auth.signInWithPassword({ email, password });
    },
    async resetPassword(email, redirectTo = CASA_CLARA_REDIRECT_URL) {
      if (!client) return fail(new Error('Supabase no está configurado.'));
      return client.auth.resetPasswordForEmail(email, { redirectTo: CASA_CLARA_REDIRECT_URL });
    },
    async updatePassword(password) {
      if (!client) return fail(new Error('Supabase no está configurado.'));
      return client.auth.updateUser({ password });
    },
    async signOut() {
      if (!client) return { error: null };
      return client.auth.signOut();
    },
    async loadData() {
      if (!client) return fail(new Error('Supabase no está configurado.'));
      const [members, accounts, transactions, recurringPayments] = await Promise.all([
        client.from('household_members').select('household_id,user_id,display_name,role'),
        client.from('accounts').select('id,household_id,owner_id,name,kind,opening_balance'),
        client.from('transactions').select('id,account_id,created_by,description,category,amount,type,occurred_on').order('occurred_on', { ascending: false }),
        client.from('recurring_payments').select('id,account_id,created_by,name,amount,due_day,status').order('due_day', { ascending: true })
      ]);
      const problem = [members, accounts, transactions, recurringPayments].find((result) => result.error);
      if (problem) return { data: null, error: problem.error };
      return {
        data: { members: members.data || [], accounts: accounts.data || [], transactions: transactions.data || [], payments: recurringPayments.data || [] },
        error: null
      };
    },
    async addTransaction(payload) {
      if (!client) return fail(new Error('Supabase no está configurado.'));
      return client.from('transactions').insert(payload).select('id,account_id,created_by,description,category,amount,type,occurred_on').single();
    },
    async addRecurringPayment(payload) {
      if (!client) return fail(new Error('Supabase no está configurado.'));
      return client.from('recurring_payments').insert(payload).select('id,account_id,created_by,name,amount,due_day,status').single();
    },
    async updateRecurringPayment(id, payload) {
      if (!client) return fail(new Error('Supabase no está configurado.'));
      return client.from('recurring_payments').update(payload).eq('id', id).select('id,account_id,created_by,name,amount,due_day,status').single();
    }
  };
})();
