CREATE TABLE IF NOT EXISTS vm_hourly (
	vm_id VARCHAR(64) NOT NULL,
	hour_timestamp TIMESTAMP NOT NULL,
	cpu_avg DOUBLE PRECISION,
	cpu_max DOUBLE PRECISION,
	cpu_p95 DOUBLE PRECISION,
	mem_avg DOUBLE PRECISION,
	mem_p95 DOUBLE PRECISION,
	net_in_mb DOUBLE PRECISION,
	net_out_mb DOUBLE PRECISION,
	vcpu_count INT,
	mem_gb FLOAT,
	hourly_price DOUBLE PRECISION,
	owner VARCHAR(64),
	env VARCHAR(32),
	role VARCHAR(32),
	created_at TIMESTAMP,
	deleted_at TIMESTAMP,
	is_idle BOOLEAN DEFAULT FALSE,
	PRIMARY KEY (vm_id, hour_timestamp)
);

CREATE TABLE IF NOT EXISTS vm_findings (
	vm_id VARCHAR(64) PRIMARY KEY,
	finding_type VARCHAR(32) NOT NULL, -- 'ZOMBIE' || 'OVERSIZED'
	owner VARCHAR(64),
	env VARCHAR(32),
	role VARCHAR(32),
	vcpu_count INT,
	mem_gb DOUBLE PRECISION,
	hourly_price DOUBLE PRECISION,
	idle_hours INT DEFAULT 0,
	waste_so_far DOUBLE PRECISION DEFAULT 0.0,
	projected_monthly_waste DOUBLE PRECISION DEFAULT 0.0,
	current_instance_type VARCHAR(32),
	recommended_instance_type VARCHAR(32),
	monthly_savings DOUBLE PRECISION DEFAULT 0.0,
	confidence VARCHAR(16) NOT NULL, --'High' || 'Low'
	action VARCHAR(32) NOT NULL, --'TERMINATE' || 'DOWNSIZE'
	explanation TEXT -- Plain-French explainin' reason for flaggin'
);

CREATE TABLE IF NOT EXISTS spike_alerts (
	vm_id VARCHAR(64) NOT NULL,
	alert_timestamp TIMESTAMP NOT NULL,
	baseline_mean DOUBLE PRECISION,
	baseline_stddev DOUBLE PRECISION,
	observed_value DOUBLE PRECISION,
	z_score DOUBLE PRECISION,
	duration_hours INT,
	excess_cost DOUBLE PRECISION,
	PRIMARY KEY (vm_id, alert_timestamp)
);

CREATE TABLE IF NOT EXISTS savings_summary (
	category VARCHAR(64) NOT NULL,
	env VARCHAR(32) NOT NULL,
	total_waste DOUBLE PRECISION DEFAULT 0.0,
	machine_count INT DEFAULT 0,
	projected_savings DOUBLE PRECISION DEFAULT 0.0,
	PRIMARY KEY (category, env)
);

CREATE INDEX IF NOT EXISTS idx_findings_type ON vm_findings(finding_type);
CREATE INDEX IF NOT EXISTS idx_findings_filters ON vm_findings(owner, env, confidence);
CREATE INDEX IF NOT EXISTS idx_hourly_vm ON vm_hourly(vm_id);
