import { Injectable, BadRequestException } from '@nestjs/common';
import { SupabaseService } from '../supabase/supabase.service';

export interface CreateAuditLogDto {
  admin_id: string;
  action: string;
  resource_type: string;
  resource_id?: string;
  details?: Record<string, any>;
  ip_address?: string;
  user_agent?: string;
}

@Injectable()
export class AuditLogsService {
  constructor(private readonly supabaseService: SupabaseService) {}

  /**
   * Create an audit log entry
   */
  async createLog(dto: CreateAuditLogDto) {
    const supabase = this.supabaseService.getClient();

    const { error } = await supabase.from('audit_logs').insert({
      admin_id: dto.admin_id,
      action: dto.action,
      resource_type: dto.resource_type,
      resource_id: dto.resource_id || null,
      details: dto.details || {},
      ip_address: dto.ip_address || null,
      user_agent: dto.user_agent || null,
      created_at: new Date().toISOString(),
    });

    if (error) {
      console.error('Failed to create audit log:', error);
      // Don't throw error - logging should not break the main operation
    }
  }

  /**
   * Get audit logs with pagination
   */
  async getLogs(page: number = 1, limit: number = 20, filters?: {
    admin_id?: string;
    resource_type?: string;
    action?: string;
    start_date?: string;
    end_date?: string;
  }) {
    const supabase = this.supabaseService.getClient();
    const offset = (page - 1) * limit;

    let query = supabase
      .from('audit_logs')
      .select(`
        *,
        admin:profiles!audit_logs_admin_id_fkey(id, full_name, email, avatar_url)
      `, { count: 'exact' });

    // Apply filters
    if (filters?.admin_id) {
      query = query.eq('admin_id', filters.admin_id);
    }
    if (filters?.resource_type) {
      query = query.eq('resource_type', filters.resource_type);
    }
    if (filters?.action) {
      query = query.eq('action', filters.action);
    }
    if (filters?.start_date) {
      query = query.gte('created_at', filters.start_date);
    }
    if (filters?.end_date) {
      query = query.lte('created_at', filters.end_date);
    }

    const { data, error, count } = await query
      .order('created_at', { ascending: false })
      .range(offset, offset + limit - 1);

    if (error) {
      throw new BadRequestException(`Lỗi khi lấy audit logs: ${error.message}`);
    }

    return {
      data: data || [],
      meta: {
        total: count || 0,
        page,
        limit,
        totalPages: Math.ceil((count || 0) / limit),
      },
    };
  }

  /**
   * Get audit log detail
   */
  async getLogDetail(id: string) {
    const supabase = this.supabaseService.getClient();

    const { data, error } = await supabase
      .from('audit_logs')
      .select(`
        *,
        admin:profiles!audit_logs_admin_id_fkey(id, full_name, email, avatar_url)
      `)
      .eq('id', id)
      .single();

    if (error) {
      throw new BadRequestException(`Không tìm thấy audit log với ID: ${id}`);
    }

    return data;
  }

  /**
   * Get audit log statistics
   */
  async getLogStats(days: number = 30) {
    const supabase = this.supabaseService.getClient();
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - days);

    const { data, error } = await supabase
      .from('audit_logs')
      .select('action, resource_type, created_at')
      .gte('created_at', startDate.toISOString());

    if (error) {
      throw new BadRequestException(`Lỗi khi lấy thống kê audit logs: ${error.message}`);
    }

    // Calculate stats
    const stats = {
      total_logs: data?.length || 0,
      by_action: {} as Record<string, number>,
      by_resource: {} as Record<string, number>,
      by_day: {} as Record<string, number>,
    };

    data?.forEach((log) => {
      // Count by action
      stats.by_action[log.action] = (stats.by_action[log.action] || 0) + 1;

      // Count by resource
      stats.by_resource[log.resource_type] = (stats.by_resource[log.resource_type] || 0) + 1;

      // Count by day
      const day = log.created_at.split('T')[0];
      stats.by_day[day] = (stats.by_day[day] || 0) + 1;
    });

    return stats;
  }
}
