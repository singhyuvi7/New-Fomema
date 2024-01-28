# monitor reasons
[
    ['1', 'PASSPORT CHANGES REPORT', 'PASSCHG'],
    ['2', 'FIT INDICATOR CHANGES', 'FITINDCHG'],
    ['3', 'REUSED PASSPORT NUMBER', 'REUSEPASS'],
    ['4', 'X-RAY RELATED TCUPI CASES', 'XTCUPI'],
    ['5', 'NON X-RAY RELATED TCUPI CASES', 'TCUPI'],
    ['6', 'RENEWAL OF KNOWN UNFIT WORKER', 'RENEWUNFIT'],
    ['7', 'BLOOD GROUP & RH CHANGES', 'BLOODCHG'],
    ['8', 'INCOMPLETE TRANSACTION WITH ABNORMAL CONDITIONS', 'INCOMPTRAN'],
    ['9', 'OTHERS', 'OTHERS']
].each do |arr|
    MonitorReason.create!({
        code: arr[0],
        description: arr[1],
        short_description: arr[2],
    })
end
puts("monitor reasons seeded")